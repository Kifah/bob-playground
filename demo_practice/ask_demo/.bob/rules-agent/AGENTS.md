# AGENTS.md — Agent Mode Rules (Demo Workspace)

This configuration guides IBM Bob in **Agent Mode** during codebase analysis, testing, or maintenance tasks.

---

## 🎯 Purpose & Scope
This workspace is configured for inspecting and evaluating enterprise Java applications.

---

## 📐 Coding & Architecture Standards
- **Spring Boot & Java Standards**: Follow clean layered architecture (Controller → Service → Repository/DAO → Database).
- **Uncle Bob's Clean Code**: Single responsibility per service method, descriptive naming, and Boy Scout rule.
- **Testing**: Follow JUnit Arrange-Act-Assert (AAA) pattern.
- **Safety First**: Verify all changes against test suites before committing.
