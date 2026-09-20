# AGENTS.md — Agent Mode Rules (Demo Workspace)

This configuration guides IBM Bob in **Agent Mode** during the live IBAN Checker coding demonstration.

---

## 🎯 Purpose & Scope
This workspace is designed to build, compile, test, and execute a standalone, dependency-free Java 21 CLI application for validating German IBAN numbers.

---

## 📐 Architecture & Coding Standards

### Pure Java CLI Architecture
- **Zero Framework Overhead**: Standard Java 21 only (no Spring Boot, no external libraries beyond JUnit 5).
- **Package & Class Structure**: Single class `IbanChecker` in package `com.example.iban` (`src/main/java/com/example/iban/IbanChecker.java`).
- **Deterministic Validation**: Core validation method `public static boolean validate(String iban)` must be pure, thread-safe, and side-effect free.

### Clean Code Principles (Uncle Bob)
- **Single Responsibility**: Methods should do one thing, do it well, and do it only. Keep validation and sanitisation logic small and focused (< 20 lines).
- **Intention-Revealing Names**: Use clear, self-explanatory variable and method names.
- **The Boy Scout Rule**: Always leave the code cleaner than you found it.

---

## ⚙️ CLI Contract & Argument Handling

### Output Contract
- Print `PASS` to `stdout` if the IBAN is valid.
- Print `FAIL` to `stdout` if the IBAN is invalid, empty, null, or missing.
- **No Error Exits**: Always return exit code `0` (never call `System.exit(1)` or print usage errors to `System.err`).

### Argument Robustness
- In `main(String[] args)`:
  - If `args` is null or empty, print `FAIL`.
  - Otherwise, join tokens using `String.join(" ", args)` before calling `validate(...)` to handle spaced CLI arguments cleanly across all shells.

---

## 🧪 Testing Standards (JUnit 5)

- **Test Framework**: `org.junit.jupiter.api` (JUnit 5 Jupiter).
- **Pattern**: Arrange-Act-Assert (AAA) pattern for all test methods.
- **Naming Convention**: `should_<expectedResult>_when_<condition>` (e.g. `should_returnPass_when_validGermanIbanProvided`).
- **Required Test Coverage**:
  - Valid German IBANs (22 chars, starts with `DE`).
  - Formatted IBANs with whitespace/spaces.
  - Invalid prefixes (e.g., `FR...`, `GB...`).
  - Boundary lengths (too short, too long).
  - Null, empty string, and missing CLI input.
- **Performance**: Tests must run completely in-memory in milliseconds with zero network dependencies.

---

## 🛠️ Build & Makefile Standards
Provide a standard `Makefile` with the following targets:
- `make build` — Compiles sources and packages the executable JAR via Maven.
- `make test` — Executes JUnit 5 test suite.
- `make run IBAN="..."` — Runs `mvn -q exec:java -Dexec.mainClass=com.example.iban.IbanChecker -Dexec.args="$(IBAN)"`.
- `make clean` — Cleans up the `target/` directory.
- `make help` — Displays available Makefile commands and descriptions.
