# IBM Bob Presentation — Quick Copy-Paste Prompts

A handy reference sheet of all demo prompts for the IBM Bob live presentation.

---

## 📋 Table of Contents

- [Live Demo Sequence (§12)](#live-demo-sequence-12)
  - [Part 1 — Plan Mode: Design Before Coding](#part-1--plan-mode-design-before-coding)
  - [Part 2 — Agent Mode: Generate the Project](#part-2--agent-mode-generate-the-project)
  - [Part 3 — Execute: Run CLI Tests](#part-3--execute-run-cli-tests)
  - [Part 4 — Literate Coding: Support Spaces](#part-4--literate-coding-support-spaces)
  - [Part 5 — Ask Mode: Explain the Code](#part-5--ask-mode-explain-the-code)
  - [Part 6 — /init: Persistent Project Memory](#part-6--init-persistent-project-memory)
  - [Part 7 — Rollback: Safe Experimentation](#part-7--rollback-safe-experimentation)
  - [Part 8 (Optional) — Custom Slash Command](#part-8-optional--custom-slash-command)
- [Prompt Playbook (§12b)](#prompt-playbook-12b)
  - [Playbook Prompt 1: Scaffold Pure Java CLI](#playbook-prompt-1-scaffold-pure-java-cli)
  - [Playbook Prompt 2: Comprehensive JUnit 5 Tests](#playbook-prompt-2-comprehensive-junit-5-tests)
  - [Playbook Prompt 3: Runnable Fat JAR Configuration](#playbook-prompt-3-runnable-fat-jar-configuration)
  - [Playbook Prompt 4: Explain Codebase (Ask Mode)](#playbook-prompt-4-explain-codebase-ask-mode)
- [CLI Quick Run Reference](#cli-quick-run-reference)

---

## Live Demo Sequence (§12)

### Part 1 — Plan Mode: Design Before Coding
**Mode:** Plan  
**Target:** [`ibm-bob-presentation.md:1001`](ibm-bob-presentation.md:1001)

```
I want to build a pure Java CLI application (single class with main method, no external frameworks, no Spring Boot) that validates German IBAN numbers passed as a command-line argument.

Requirements:
- Input: In main(String[] args), join all arguments with String.join(" ", args) if args is non-empty, so spaced inputs are handled cleanly
- Initial validation rules in validate(String iban):
  1. Must start with "DE"
  2. Total length must be exactly 22 characters without spaces (e.g. "DE89370400440532013000")
  3. Formatted IBANs containing whitespace between numbers/characters must NOT be allowed in this initial version (must return false / FAIL)
- Output:
  - Prints "PASS" to stdout if valid
  - Prints "FAIL" to stdout if invalid, and prints "FAIL" if no IBAN / arguments are provided (never System.exit(1) or stderr usage message)
- Makefile with targets: build, test, run (e.g. `make run IBAN="DE..."`)
- Single class: IbanChecker.java in package com.example.iban

Create a plan for this project as a checklist in a plan.md file.
```

---

### Part 2 — Agent Mode: Generate the Project
**Mode:** Agent  
**Target:** [`ibm-bob-presentation.md:1031`](ibm-bob-presentation.md:1031)

```
Implement the plan in plan.md. Do not run anything yet.
```

---

### Part 3 — Execute: Run CLI Tests
**Mode:** Agent
**Target:** [`ibm-bob-presentation.md:1061`](ibm-bob-presentation.md:1061)

```
Run the test cases using make run.
```

**Verification commands (in terminal / workspace directory):**
```bash
# Valid German IBAN -> prints PASS
make run IBAN="DE89370400440532013000"

# Invalid prefix -> prints FAIL
make run IBAN="FR1420041010050500013M02606"

# Invalid length -> prints FAIL
make run IBAN="DE123"

# Missing argument -> prints FAIL
make run

# Spaced IBAN before Literate Coding -> prints FAIL (sets up Part 4)
make run IBAN="DE89 3704 0044 0532 0130 00"

# Run all unit tests
make test
```

---

### Part 4 — Literate Coding: Support Spaces
**Tool:** Inline Editor (`Cmd+I` / `Ctrl+I` in `IbanChecker.java`)
**Target:** [`ibm-bob-presentation.md:1085`](ibm-bob-presentation.md:1085)

```
// Strip all whitespace/spaces from the input IBAN before checking prefix and length. Also update or add unit tests in IbanCheckerTest if needed to verify formatted IBANs with spaces.
```

**Verification commands after accepting the diff:**
```bash
# Rebuild first to compile the updated source
make build

# Spaced German IBAN -> now prints PASS!
make run IBAN="DE89 3704 0044 0532 0130 00"

# Re-run unit tests
make test
```

---

### Part 5 — Ask Mode: Explain the Code
**Mode:** Ask  
**Target:** [`ibm-bob-presentation.md:1103`](ibm-bob-presentation.md:1103)

```
@/src/main/java/com/example/iban/IbanChecker.java
Explain how the validate method handles null and whitespace sanitisation, and why the method design is pure and thread-safe.
```

---

### Part 6 — /init: Persistent Project Memory
**Mode:** Agent  
**Target:** [`ibm-bob-presentation.md:1121`](ibm-bob-presentation.md:1121)

```
/init
```

---

### Part 7 — Rollback: Safe Experimentation
**Mode:** Agent
**Target:** [`ibm-bob-presentation.md:1140`](ibm-bob-presentation.md:1140)

```
Change the valid output message from PASS to OK_VALIDATED
```
*(After approving, demonstrate Rollback via the chat UI hover menu).*

**Verification commands:**
```bash
# Verify the changed output message before rollback:
make run IBAN="DE89370400440532013000"
# Expected output: OK_VALIDATED

# After clicking Rollback in chat UI, verify restoration to PASS:
make run IBAN="DE89370400440532013000"
# Expected output: PASS
```

---

### Part 8 (Optional) — Custom Slash Command
**File created:** `.bob/commands/check-code.md`  
**Command:** `/check-code`  
**Target:** [`ibm-bob-presentation.md:1160`](ibm-bob-presentation.md:1160)

```markdown
Review the current open file for:
- Edge case handling (nulls, empty strings, Unicode whitespace)
- Performance and memory allocations
- Clean single-responsibility method design
Provide specific, actionable feedback with code examples.
```

---

## Prompt Playbook (§12b)

### Playbook Prompt 1: Scaffold Pure Java CLI
**Mode:** Agent  
**Target:** [`ibm-bob-presentation.md:1185`](ibm-bob-presentation.md:1185)

```
Create a pure Java CLI application for German IBAN validation using Java 21 with Maven.

Requirements:
- Pure standard Java (no Spring Boot, no external framework dependencies)
- Main class: src/main/java/com/example/iban/IbanChecker.java
- Method: public static boolean validate(String iban)
  - Return true if it starts with "DE" and has exact length of 22 characters without spaces (e.g. "DE89370400440532013000")
  - Whitespace between characters/digits is NOT allowed in this initial version (return false)
  - Return false for any null, empty, wrong prefix, or wrong length input
- Method: public static void main(String[] args)
  - If args is empty, null, or no IBAN is provided -> System.out.println("FAIL")
  - Otherwise, call validate(String.join(" ", args)) and print "PASS" (if true) or "FAIL" (if false)
- pom.xml: include only junit-jupiter for unit testing

Do not add extra dependencies.
Do not run the application yet.
```

---

### Playbook Prompt 2: Comprehensive JUnit 5 Tests
**Mode:** Agent
**Target:** [`ibm-bob-presentation.md:1212`](ibm-bob-presentation.md:1212)

```
Write comprehensive JUnit 5 unit tests for IbanChecker in src/test/java/com/example/iban/IbanCheckerTest.java.

Requirements:
- Test valid German IBANs (e.g. "DE89370400440532013000", "DE89 3704 0044 0532 0130 00", lowercase "de89...") -> assert true
- Test invalid country prefixes (e.g. "FR1420041010050500013M02606", "GB82WEST12345698765432") -> assert false
- Test invalid lengths (too short like "DE12345", too long like "DE89370400440532013000999") -> assert false
- Test null and blank strings -> assert false
- Test main(String[] args) output streams for "PASS" and "FAIL"

After creating the file, explain how to run the test suite via Maven.
```

**Verification:**
```bash
make test
```

---

### Playbook Prompt 3: Runnable Fat JAR Configuration
**Mode:** Agent
**Target:** [`ibm-bob-presentation.md:1234`](ibm-bob-presentation.md:1234)

```
Configure Maven in pom.xml to build a standalone runnable JAR for the IBAN Checker CLI.

Requirements:
- Use maven-shade-plugin or maven-jar-plugin
- Set mainClass to com.example.iban.IbanChecker
- Ensure the user can run: java -jar target/iban-checker.jar "DE89370400440532013000"

Explain the exact terminal commands to package and execute the JAR.
```

**Verification:**
```bash
make build
java -jar target/iban-checker.jar "DE89370400440532013000"
```

---

### Playbook Prompt 4: Explain Codebase (Ask Mode)
**Mode:** Ask  
**Target:** [`ibm-bob-presentation.md:1277`](ibm-bob-presentation.md:1277)

```
@https://github.com/ohbus/retail-banking

Explain this banking application to a new backend developer joining the team.
Do not suggest any code changes.
```

---

## CLI Quick Run Reference

| Test Case | Command | Expected Output |
|-----------|---------|-----------------|
| Valid DE IBAN | `make run IBAN="DE89370400440532013000"` | `PASS` |
| Invalid Prefix | `make run IBAN="FR1420041010050500013M02606"` | `FAIL` |
| Short Length | `make run IBAN="DE123"` | `FAIL` |
| Missing Argument | `make run` | `FAIL` |
| Spaced DE IBAN | `make run IBAN="DE89 3704 0044 0532 0130 00"` | `PASS` *(after Literate Coding)* |
| Unit Tests | `make test` | `All tests pass` |
