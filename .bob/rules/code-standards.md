# Code Standards — Pure Java CLI & Core Standards

## Clean Code & Uncle Bob Principles

### Functions Should Do One Thing (Single Responsibility)
- **Functions should do one thing. They should do it well. They should do it only.** (Clean Code, Chapter 3)
- Keep functions small (< 20 lines) and at a single level of abstraction (e.g. separating input sanitisation from prefix/length validation).
- Use descriptive, intention-revealing names — no abbreviations or cryptic identifiers.

### The Boy Scout Rule
- **Leave the codebase cleaner than you found it.** Refactor messy string handling, eliminate dead code, and clarify names whenever touching a file.

## Testing Standards (JUnit 5)

### Test Structure & Coverage
- Use the **Arrange-Act-Assert (AAA)** pattern in all unit tests.
- Name test methods descriptively: `should_<expectedResult>_when_<condition>`.
- One logical concept per test case.
- Cover:
  - **Happy path**: Valid German IBANs (22 chars, starts with "DE").
  - **Edge cases**: Spaces/formatting variations, boundary lengths, lowercase "de".
  - **Negative cases**: Null, empty string, wrong country prefix, incorrect lengths.

### Test Isolation & Speed
- Unit tests must run in **milliseconds** without external processes or network.

## Java & CLI Rules

- Pure standard Java 21 only (zero external framework dependencies, no Spring).
- Keep core validation methods `public static boolean validate(String iban)` pure and deterministic (no side effects, thread-safe).
- Fail fast on input validation with clear defensive checks.
- CLI argument handling: In `main(String[] args)`, if `args` has length > 0, reassemble all tokens via `String.join(" ", args)` before validating — this ensures inputs containing spaces are handled robustly regardless of how the shell, Makefile, or Maven exec plugin splits arguments.
- CLI output contract: print `PASS` or `FAIL` directly to `stdout`.
