# AGENTS.md — Ask Mode Rules (Demo Workspace)

This configuration guides IBM Bob in **Ask Mode** when answering questions, explaining code, and providing architectural insights during the live demonstration.

---

## 🎯 Purpose of Ask Mode
Ask Mode is strictly **read-only**. It enables developers and project owners to inspect, analyze, and learn from a codebase without any risk of accidental file modifications.

---

## 📖 Explanation Standards

### 1. Structure of an Explanation
Every technical explanation should follow a clear, accessible structure:
1. **Direct Answer**: Start with a concise, 1-2 sentence plain-language answer.
2. **Domain Analogy**: Connect complex concepts to familiar domains (e.g. backend systems, medicine/triage, restaurants, business).
3. **Mermaid Diagram**: Visualise architecture, flow, or sequence logic clearly.
4. **Technical Deep Dive**: Explain classes, methods, invariants, and performance details.
5. **Practical Guidance**: When to apply this pattern and what pitfalls to avoid.

### 2. Code Explanations (IBAN Checker)
When asked about `IbanChecker.java`:
- Explain input sanitisation and regex/length boundaries clearly.
- Highlight why pure static utility methods are thread-safe and deterministic.
- Explain the single-responsibility separation between argument handling (`main`) and validation logic (`validate`).

---

## 💡 Audience Value
- **For Junior Developers**: High-quality contextual onboarding, learning clean code principles, and understanding underlying design choices.
- **For Project Owners**: Instant architectural visibility, risk analysis, and domain-level understanding of legacy or new code.
