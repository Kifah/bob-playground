# Demo Prompts Playbook — Pure Java CLI IBAN Checker

These ready-to-use prompts guide you through the live demonstration of IBM Bob 2.x using a **pure Java CLI IBAN Checker** (no Spring Boot, no external frameworks, no REST API).

---

## 1. Plan Mode — Design the CLI Tool

**Mode:** `Plan`  
**Goal:** Design the pure Java architecture with basic validation rules (length == 22 and starts with "DE") before writing code.

```
I want to build a pure Java CLI application (single class with main method, no external frameworks, no Spring Boot) that validates German IBAN numbers passed as a command-line argument.

Requirements:
- Input: IBAN string passed as CLI argument (args[0])
- Initial validation rules:
  1. Must start with "DE"
  2. Total length must be exactly 22 characters (e.g. "DE89370400440532013000")
- Output:
  - Prints "PASS" to stdout if valid
  - Prints "FAIL" to stdout if invalid or missing arguments
- Single class: IbanChecker.java in package com.example.iban

Create a plan for this project as a checklist in a plan.md file.
```

---

## 2. Agent Mode — Implement the CLI Validator & Unit Tests

**Mode:** `Agent`  
**Goal:** Implement the minimal pure Java class and JUnit 5 unit tests for the initial rule set.

```
Implement the plan from plan.md. Generate a lightweight pure Java Maven project:
- Java 21
- Main class: src/main/java/com/example/iban/IbanChecker.java with:
  - public static boolean validate(String iban) -> checks startsWith("DE") and length() == 22
  - public static void main(String[] args) -> prints "PASS" or "FAIL"
- Test class: src/test/java/com/example/iban/IbanCheckerTest.java with JUnit 5 covering:
  - Valid DE IBAN without spaces ("DE89370400440532013000") -> PASS
  - Invalid prefix (e.g. "FR1420041010050500013M02606") -> FAIL
  - Invalid length ("DE123456") -> FAIL
  - Null / empty string / missing CLI argument -> FAIL
- pom.xml with only junit-jupiter dependency (no Spring, no extra dependencies)

Do not run the application yet.
```

---

## 3. Terminal Execution & Initial Testing

**Mode:** `Agent`  
**Goal:** Compile and run directly via CLI with sample IBANs.

**Compile:**
```sh
javac -d target/classes src/main/java/com/example/iban/IbanChecker.java
```

**Run test cases:**
```sh
# 1. Valid German IBAN -> PASS
java -cp target/classes com.example.iban.IbanChecker "DE89370400440532013000"

# 2. Invalid prefix (French IBAN) -> FAIL
java -cp target/classes com.example.iban.IbanChecker "FR1420041010050500013M02606"

# 3. Invalid length (too short) -> FAIL
java -cp target/classes com.example.iban.IbanChecker "DE123456"

# 4. IBAN with spaces (fails initially before refactoring) -> FAIL
java -cp target/classes com.example.iban.IbanChecker "DE89 3704 0044 0532 0130 00"

# 5. Missing argument -> FAIL
java -cp target/classes com.example.iban.IbanChecker
```

---

## 4. Live Demonstration Improvement — Support Formatted IBANs (with Spaces)

**Feature:** Literate Coding (`Cmd+I` / `Ctrl+I`) or Agent Mode  
**Goal:** Enhance the validator to strip whitespace, allowing formatted IBANs like `"DE89 3704 0044 0532 0130 00"`.

### Option A: Literate Coding (Inline in Editor)
1. Open `IbanChecker.java` in the editor.
2. Press `Cmd+I` (Mac) / `Ctrl+I` (Win/Linux) above `validate(String iban)`.
3. Type:
```
// Strip all spaces/whitespace from the input IBAN before checking prefix and length
```
4. Press `Cmd+Enter` → Accept diff.

### Option B: Agent Mode Prompt
```
Enhance IbanChecker.java so that IBANs formatted with spaces (e.g. "DE89 3704 0044 0532 0130 00") are also accepted:
- Strip all whitespace from the input string before checking that it starts with "DE" and has 22 characters
- Update IbanCheckerTest.java to include test cases with spaces
```

**Re-test in Terminal:**
```sh
# Now passes with spaces:
java -cp target/classes com.example.iban.IbanChecker "DE89 3704 0044 0532 0130 00"
# Output: PASS
```

---

## 5. Ask Mode — Code Understanding & Logic Walkthrough

**Mode:** `Ask`  
**Goal:** Demonstrate Bob explaining code and logic without edits.

```
@/src/main/java/com/example/iban/IbanChecker.java
Explain how the validate method handles whitespace removal, validates the DE prefix and 22-character length, and how the CLI entry point processes arguments.
```

---

## 6. Slash Command — Code Review

**Mode:** `Ask` or slash command `/review`  
**Goal:** Run a clean review on the pure Java class.

```
/review
```

*Or custom review prompt:*
```
Review IbanChecker.java for:
- Edge case handling (null, empty strings, Unicode whitespace)
- Performance and memory allocations
- Clean single-responsibility method design
```

---

## 7. Real-World Codebase Analysis (Banking Domain)

**Mode:** `Ask`  
**Goal:** Demonstrate Bob's architectural breakdown on an external repository.

```
@https://github.com/ohbus/retail-banking

Explain this banking application to a new backend developer joining the team.
Do not suggest any code changes.
```
