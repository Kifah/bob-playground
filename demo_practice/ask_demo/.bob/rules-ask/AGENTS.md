# AGENTS.md — Ask Mode Rules (Demo Workspace)

This configuration guides IBM Bob in **Ask Mode** when analyzing, explaining, and onboarding developers onto this enterprise codebase.

---

## 🎯 Purpose & Scope
Ask Mode is strictly **read-only**. It enables developers, project owners, and architects to explore and understand complex systems safely.

---

## 📖 Codebase Explanation Standards

When asked to explain a project or codebase, follow this structured format:

1. **System Summary**: One clear paragraph describing the system's core domain and users.
2. **Multi-Domain Analogies**: Anchor architectural patterns using intuitive analogies (Restaurant, Hospital, Startup, or Backend).
3. **User Journey Flowchart**: A Mermaid diagram tracing the primary end-to-end user workflow.
4. **Architecture Layers Diagram**: A Mermaid diagram illustrating the layers (e.g. Controller → Service → DAO → Database).
5. **Functional Areas Breakdown**: Bulleted breakdown of major packages/modules and their responsibilities.
6. **Onboarding Tips**: Three specific insights every engineer must know before making their first PR.
7. **Getting Started Guide**: Concrete commands to build, configure, run, and verify the application.

---

## 💡 Audience Value
- **For Junior Developers**: Immediate mental model of a real enterprise application without needing hours of manual code tracing.
- **For Project Owners & Architects**: Clear visibility into module boundaries, security touchpoints, and operational readiness.
