---
name: tdd
description: >-
  Use this skill whenever you are instructed to develop a new feature, fix a bug, or write code using Test Driven Development (TDD) principles. It guides you through the Red-Green-Refactor cycle.
---

# Test Driven Development (TDD) Skill

This skill enforces the Test Driven Development (TDD) workflow, consisting of the Red-Green-Refactor cycle. You must strictly follow these steps when developing features or fixing bugs under TDD.

## The TDD Cycle

### 1. Red (Write a failing test)
- Understand the next small requirement or functionality to implement.
- Write a unit test for this specific requirement *before* writing any implementation code.
- Run the test suite. Ensure the newly added test **fails**. If it passes, the test is either flawed or the feature already exists.
- The test must fail for the right reason (e.g., missing function, incorrect return value) rather than a syntax error.

### 2. Green (Make the test pass)
- Write the **minimum amount of implementation code** necessary to make the failing test pass.
- Do not add extra functionality or over-engineer the solution at this stage. Focus solely on satisfying the test.
- Run the test suite again. Ensure the new test and all existing tests **pass**.

### 3. Refactor (Improve the code)
- Review the code you just wrote. Look for code duplication, poor naming, or complex logic.
- Refactor the code to improve its structure, readability, and performance without changing its behavior.
- Ensure you apply design patterns or clean code principles where applicable.
- Run the test suite again after refactoring to ensure all tests still **pass**.

## Best Practices
- **Small Steps**: Keep each iteration of the cycle small. Only test and implement one small behavior at a time.
- **Run Tests Frequently**: Every time you modify tests or implementation code, run the tests immediately to verify your changes.
- **Test the Interface, Not the Implementation**: Tests should verify the behavior and output of the code, not the internal details of how it's implemented.
- **Clean Up**: If a test becomes obsolete or redundant during refactoring, remove or update it.

## Execution Checklist
Before declaring the implementation complete for a requirement, verify:
- [ ] A test was written first and observed to fail.
- [ ] Code was written to make the test pass.
- [ ] The code was reviewed for potential refactoring.
- [ ] All tests are currently passing.
