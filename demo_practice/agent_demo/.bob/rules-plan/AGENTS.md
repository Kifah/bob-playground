# AGENTS.md — Plan Mode Rules (Demo Workspace)

This configuration guides IBM Bob in **Plan Mode** when architecting and designing tasks in the demo workspace.

---

## 🎯 Purpose of Plan Mode
Plan mode is dedicated to exploring, designing, and architecting solutions before any code or build files are modified. In Plan mode, Bob creates structured checklists, defines architectural contracts, and outlines verification strategies.

---

## 📋 Planning Guidelines

### 1. Structure Over Immediacy
- Always outline an actionable step-by-step checklist (e.g. `plan.md`).
- Define exact file paths, package structures, and method signatures up front.
- State clear input/output expectations and error handling boundaries.

### 2. Concrete Constraints for the IBAN Checker CLI
- **Language & Runtime**: Pure Java 21, zero framework dependencies.
- **Package**: `com.example.iban.IbanChecker`.
- **Validation Contract**:
  - Valid German IBAN: starts with `"DE"`, exact length of 22 characters.
  - Spaced IBANs handled via input sanitisation (`String.join(" ", args)` in `main` and whitespace stripping).
  - Terminal output: Always print `PASS` or `FAIL` to `stdout` with exit code `0`.
- **Testing**: Dedicated JUnit 5 unit test class (`IbanCheckerTest.java`) implementing AAA pattern.
- **Build & Workflow**: Standard `Makefile` wrapping Maven commands (`build`, `test`, `run`, `clean`).

---

## 💡 Audience Value
- **For Junior Developers**: Demonstrates the habit of structured thinking, defining boundaries, and planning test cases before writing code.
- **For Project Owners & Architects**: Shows predictable AI behavior — ensuring requirements, edge cases, and architectural constraints are validated before touching the repository.
