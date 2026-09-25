# AGENTS.md — Plan Mode Rules (Demo Workspace)

This file provides guidance to agents when working with code in this repository.

## Architectural Constraints

- **Liquibase is forward-only.** Never plan rollbacks; schema changes must be additive. Each new changeset gets its own numbered file in `db/changelog/changes/`.
- **DAOs extend `CrudRepository`, not `JpaRepository`.** Plans that require JPQL/`@Query` or pagination need to account for upgrading the DAO interface.
- **No `ddl-auto` safety net in prod.** `spring.jpa.hibernate.ddl-auto=none` — Hibernate will not auto-create or update schema. All structural changes must go through a Liquibase changeset.
- **`UserSecurityServiceImpl` is coupled directly to `SecurityConfig` by concrete type.** Any refactor of the user security service must maintain that exact class name and signature or update `SecurityConfig` simultaneously.
- **CSRF is disabled globally.** Any feature involving state-changing forms assumes no CSRF protection; re-enabling it requires updating all Thymeleaf templates.
- **Account number generation has no uniqueness guarantee at the application layer** — `ThreadLocalRandom.nextInt(2323, 232321474)` — collisions are only prevented by DB constraints. High-volume plans should account for this.
- **Both integration and unit tests exist but serve different purposes:** `ApplicationTests` uses Testcontainers (needs Docker), while `serviceImpl/*Test` files are `@Disabled` Mockito-based tests. Plans for new features need both.
- All commands and builds run from `retail-banking/`, not the workspace root — CI/CD pipelines must `cd retail-banking` first.
