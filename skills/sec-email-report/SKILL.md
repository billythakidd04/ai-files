---
name: sec-email-report
description: >
  Use this skill whenever the user wants to log, file, or convert a security disclosure
  or vulnerability report email into a Jira ticket. Triggers include: "log this disclosure",
  "create a Jira ticket from this security email", "turn this vulnerability report into a
  ticket", "log the report from [sender]", "file this as a security alert", "convert this
  responsible disclosure email to Jira", "make a SEC ticket from this email", or any time
  the user mentions a responsible disclosure, bug bounty, or external vulnerability report
  and wants it tracked in Jira. Always use this skill for those requests — even if the user
  just says something like "log the email from [name]" in a security context.
---

# sec-email-report

Converts an inbound security disclosure or vulnerability report email into a Jira Security Alert in the WebPros Security Issues (SEC) project.

## When you're invoked

The user will typically give you a sender name, email address, or subject line to identify the email. They may also just say "log the latest disclosure" or "file this one" with no extra detail — use context from the conversation to find it.

## Step-by-step workflow

### 1. Find the email

Search Outlook using `outlook_email_search`. Use whatever the user gave you — sender address, name, or subject keywords. If the user is vague, search for recent emails containing "responsible disclosure", "vulnerability", or "security report" sent to security@webpros.com.

If multiple emails match, pick the original inbound report (not a reply or forward from your own team). The original will typically be the oldest in the thread.

Read the full email body with `read_resource` using the URI returned by the search. Also note:
- Sender name and email address
- Recipient address (the actual `To:` field — this varies, e.g. security@webpros.com, security@cpanel.net)
- `internetMessageId` (the RFC 822 Message-ID — this is the universal, user-independent identifier for the email)
- Sent date
- Any attachment names
- Whether there are follow-up emails in the thread (check for replies)

### 2. Assess report quality

Now that you have the full email, evaluate whether it meets a minimum quality bar before doing anything else. A report is **low quality** if it exhibits any of the following:

- **No specific target** — doesn't name a WebPros product, URL, IP address, or domain. Generic reports like "your login page has a CAPTCHA bypass" with no indication of *which* login page are not actionable. A missing version number alone is not disqualifying — if a specific product or property is identifiable, the report can still be filed (and a version can be requested in the response).
- **Scatter-shot style** — reads as if sent to many companies at once, hoping someone bites. Signs include: no company name, generic "your website" language, no PoC tied to a real endpoint, or a templated structure with blanks left unfilled. A strong hard signal: the `To:` field shows `undisclosed-recipients:;` — this means the email was BCC'd to an unknown list of targets and WebPros was not specifically addressed.
- **No proof of concept** — claims a vulnerability exists but provides no reproduction steps, no request/response samples, and no screenshots or evidence.
- **Purely theoretical** — describes a vulnerability class in the abstract without demonstrating it exists in any WebPros system.

A **known bad pattern**: emails about common low-specificity issues (CAPTCHA bypass, clickjacking, open redirect, subdomain takeover, SPF/DMARC misconfiguration) that name no specific affected property are almost always low quality.

**If the report is low quality**, do not create a ticket. Instead, tell the user clearly:

> "This report appears low quality — [specific reason, e.g. 'no WebPros product or URL is mentioned and the report reads as a mass-sent template']. I'd recommend not logging it. Want me to proceed anyway?"

Wait for the user to confirm before filing. The goal is to keep the SEC backlog free of noise that wastes the team's triage time.

If the report passes the quality bar, continue to the next step.

### 3. Check for duplicates

Before creating anything, search the SEC project for existing issues that might already cover this report. Use `searchJiraIssuesUsingJql` with a query like:

```
project = SEC AND summary ~ "[key term from email subject]" ORDER BY created DESC
```

Also try searching by reporter email or name if the subject search is too broad:

```
project = SEC AND text ~ "[sender name or email]" ORDER BY created DESC
```

If a match is found, show the user the existing issue key and summary and ask whether to proceed with a new ticket or treat it as a duplicate. Don't create a ticket without confirmation if there's a plausible match.

If no match is found, continue to the next step.

### 4. Identify Jira config

These values are fixed for WebPros — no need to look them up:

| Field | Value |
|---|---|
| Cloud ID | `28e59baf-4143-44c3-b24a-c5c88f2fc909` |
| Project key | `SEC` |
| Issue type | `Security Alert` |
| Source (customfield_10739) | `e-mail to security` |
| Awareness (customfield_10738) | `Auditor` (default for external researchers; see note below) |

**Awareness field guidance:** The allowed values are: Internal, Auditor under NDA, Auditor, Customer, Media, Unknown. For an external security researcher doing responsible disclosure with no known relationship to WebPros, use `Auditor`. If context makes another value clearly more appropriate (e.g., the sender mentions they're a customer), use that instead.

**Priority guidance:** Determine on a case-by-case basis from the content of the email — do not hardcode. Allowed values in Jira are `Blocker`, `High`, `Medium`, `Low`, `Trivial`. Suggested rubric:
- `Blocker` — Active exploitation, RCE, auth bypass, mass data exposure, or anything the reporter indicates is being weaponized now. **This is a critical incident — see "Blocker handling" below.**
- `High` — Unauthenticated vulnerabilities with clear impact (SQLi, stored XSS in admin context, privilege escalation, sensitive data disclosure) but no evidence of active exploitation.
- `Medium` — Authenticated or harder-to-reach issues, CSRF without sensitive actions, reflected XSS, info leaks with limited impact.
- `Low` — Best-practice findings, missing headers, low-impact misconfigurations, theoretical issues.
- `Trivial` — Informational only, out-of-scope, or unverified speculation.

If the email is ambiguous, default to `Medium` and note your reasoning in the ticket so a human can re-triage.

**Blocker handling:** If you set priority to `Blocker`, after creating the ticket you MUST alert the user prominently in the confirmation message and tell them to start the incident response process immediately. Link them to:
- [Security Incident Response Plan](https://webpros.atlassian.net/wiki/spaces/SEC/pages/3645933233/Security+Incident+Response+Plan) — SIRT/SIRL roles and end-to-end response process
- [Process: Incident Response](https://webpros.atlassian.net/wiki/spaces/IM/pages/4966973936/Process+Incident+Response) — operational runbook, including the `#incidents` Slack channel
- [Processing of Security Alerts](https://webpros.atlassian.net/wiki/spaces/SEC/pages/3645933478/Processing+of+Security+Alerts) — step-by-step for handling open Security Alerts

Do not assume the user has already seen the alert — call it out explicitly (e.g., "⚠️ Priority set to Blocker — start the incident response process now").

### 5. Create the Jira Security Alert

Use `createJiraIssue` with:
- **summary**: A concise, descriptive title that makes the vulnerability immediately clear — do NOT just copy the email subject. Construct it as `[Product] Vulnerability type — key detail`. Examples:
  - Email subject: "CVE Request - Unauthenticated Session Fixation & OS Command Injection in cPanel/WHM" → Summary: `[cPanel/WHM] Unauthenticated Session Fixation + OS Command Injection via ajax_locale_delete_local_key.pl`
  - Email subject: "Responsible Disclosure - Click-jacking Vulnerability" → Summary: `[webpros.com] Clickjacking - Missing X-Frame-Options / CSP frame-ancestors`
  - Email subject: "Security Issue Found" → Summary: `[Product] Brief description of what was actually found`
  The goal is for someone scanning the SEC backlog to understand the vulnerability at a glance without opening the ticket.
- **description**: The full formatted email content (see template below)
- **contentFormat**: `markdown`
- **additional_fields**: include `priority`, `customfield_10738`, and `customfield_10739`

#### Description template

```markdown
## Security Alert: [Vulnerability type]

**Reported by:** [Sender name] ([sender email])
**Received:** [Date, e.g. May 11, 2026]
**Sent to:** [Actual recipient address from the email's To: field]
**Message-ID:** [internetMessageId from the email — this is the universal reference for locating the original email in Outlook]

---

## Original Email

> **From:** [Sender name] <[sender email]>
> **To:** [Actual recipient address from the email's To: field]
> **Subject:** [Email subject]
> **Date:** [Date]

[Full email body, preserved exactly]

---

## Attachments (in original email)

- `[attachment filename]`
- `[attachment filename]`

(Omit this section if there are no attachments.)

---

## Notes

[If there are follow-up emails from the reporter: "A follow-up email was received on [date] from the same reporter requesting a status update."]

[If no follow-ups, omit the Notes section entirely.]
```

Note: do not include an Outlook web link in the ticket. OWA deeplinks are session-specific and won't work for other team members. The Message-ID in the header above is the portable reference anyone can use to locate the original email.

### 6. Confirm to the user

Report back with the Jira issue key and a direct link, e.g.:

> Created **[SEC-XXXXX](https://webpros.atlassian.net/browse/SEC-XXXXX)** — "[issue summary]"

That's it. Keep it brief — the user logs a lot of these.

## Common edge cases

- **Email not found on first search**: Try relaxing the filter — search by subject keywords only, or by date range. If still not found, ask the user for clarification.
- **Sender used a different email than expected**: The email the user gives you may be a contact alias. Search by name or subject if the address yields nothing.
- **Thread with multiple emails**: Always anchor the ticket to the original inbound report, not a follow-up. Note follow-ups in the description.
- **No attachment**: Just omit the Attachments section from the description.
