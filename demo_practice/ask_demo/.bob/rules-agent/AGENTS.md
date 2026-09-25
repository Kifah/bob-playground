# AGENTS.md — Agent Mode Rules (Demo Workspace)

This file provides guidance to agents when working with code in this repository.

## Coding Rules

- All Maven commands must be run from `retail-banking/`, not the workspace root.
- Use `@Disabled` unit tests as a template when writing new service tests — un-disable by removing the annotation, not by modifying the class structure.
- New DB schema changes go in a new numbered YAML file in `src/main/resources/db/changelog/changes/`; never edit existing changesets (Liquibase is forward-only).
- Field injection (`@Autowired`) is the established pattern for all service implementations. Use constructor injection only in configuration classes.
- Monetary amounts travel as `double` between controller and service; convert to `BigDecimal` at the point of DB persistence/arithmetic inside `serviceImpl`.
- `UserSecurityServiceImpl` is wired directly into `SecurityConfig` by concrete type — do not replace it with the `UserService` interface or the security chain will break.
- `@PreAuthorize` on methods is the only access control on admin endpoints — `PUBLIC_MATCHERS` intentionally allows unauthenticated access to `/admin/**` at the URL level.
- Run `./mvnw test -Dtest=ClassName#methodName` to run a single test method.
