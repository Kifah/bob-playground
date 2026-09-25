# AGENTS.md — Ask Mode Rules (Demo Workspace)

This file provides guidance to agents when working with code in this repository.

## Codebase Explanation Standards

When asked to explain this project, follow this structured format:

1. **System Summary**: One paragraph describing the system's domain and users.
2. **Multi-Domain Analogies**: At least two analogies mapping to the architecture (Restaurant, Hospital, Startup, or Backend).
3. **User Journey Flowchart**: A Mermaid `sequenceDiagram` tracing the main happy-path user flow.
4. **Architecture Layers Diagram**: A Mermaid `flowchart LR` showing Controller → Service → DAO → MySQL, plus the Liquibase migration path.
5. **Functional Areas Breakdown**: Bulleted breakdown of `controller/`, `service/serviceImpl/`, `dao/`, `model/`, `security/`, `config/`.
6. **Onboarding Tips**: Three specific insights (e.g. all service tests are `@Disabled` by default, Testcontainers requires Docker for integration tests, Liquibase is forward-only).
7. **Getting Started Guide**: Concrete commands — run from `retail-banking/`, needs Docker for tests, default dev port is `9998`.

## Non-Obvious Context

- The `service/` directory contains only interfaces; implementations live in `service/serviceImpl/`.
- `security/` is not Spring Security config — it holds domain model classes (`Authority`, `Role`, `UserRole`). Spring Security config is in `config/`.
- All unit tests under `service/serviceImpl/` are `@Disabled` and will be skipped unless explicitly un-disabled.
- The app runs on port `9999` in prod and `9998` in dev (not the Spring Boot default of `8080`).
