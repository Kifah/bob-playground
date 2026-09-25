# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project

Spring Boot 3.4.4 / Java 21 retail banking MVC application. Single module under `retail-banking/`. All Maven commands must be run from inside that directory.

## Commands

```bash
# Run from retail-banking/
./mvnw spring-boot:run                                        # starts on port 9998 (dev) or 9999 (prod)
./mvnw test                                                   # all tests (requires Docker for Testcontainers)
./mvnw test -Dtest=UserServiceImplTest                        # single test class
./mvnw test -Dtest=UserServiceImplTest#findByUsername         # single test method
./mvnw package -DskipTests                                    # build JAR without tests
./mvnw package                                                # build + run tests + JaCoCo coverage report
```

Coverage report lands at `retail-banking/target/site/jacoco/index.html`.

## Critical: Tests

- `@SpringBootTest` integration tests (e.g. `ApplicationTests`) spin up a **Testcontainers MySQL container** — Docker must be running.
- All `serviceImpl` unit tests are annotated `@Disabled` — they are skipped by default and must be un-disabled to run them individually.
- Unit tests use `MockitoAnnotations.openMocks(this)` in `@BeforeEach`; no `@ExtendWith(MockitoExtension.class)` annotation is used.

## Critical: Database

- Schema is managed by **Liquibase** (forward-only). Never use `spring.jpa.hibernate.ddl-auto=create` or `update` in prod — it is locked to `none`.
- Dev profile (`application-dev.properties`) overrides to `ddl-auto=update` and uses `localhost:3306/bank_dev` with hardcoded `root/root`.
- Liquibase changelog entry point: `src/main/resources/db/changelog/db.changelog-master.yaml`.
- To add schema changes, create a new numbered YAML file in `db/changelog/changes/` and reference it from the master file. Never modify existing changesets.

## Architecture

```
Controller → Service interface → serviceImpl/ → DAO (CrudRepository) → MySQL
```

- DAOs are in `dao/` and extend `CrudRepository` (not `JpaRepository`).
- Service implementations live in `service/serviceImpl/` — one impl per interface.
- `UserSecurityServiceImpl` is wired directly into `SecurityConfig` (not via the `UserService` interface).

## Security

- BCrypt with strength 12; salt is the string literal `"salt"` (hardcoded in `SecurityConfig`).
- CSRF and CORS are **disabled** — do not re-enable without updating all Thymeleaf form templates.
- `/admin/**` is in `PUBLIC_MATCHERS` — unauthenticated users can access admin routes; access control is enforced at the method level via `@PreAuthorize`.
- Session policy is `ALWAYS` — sessions are created even for unauthenticated requests.

## Code Style

- Field injection via `@Autowired` is the project pattern (not constructor injection, except `SecurityConfig`).
- Account balances use `BigDecimal`; monetary amounts passed around as `double` and converted at the service layer.
- Account numbers are generated with `ThreadLocalRandom.current().nextInt(2323, 232321474)` — no uniqueness guarantee beyond what the DB enforces.
