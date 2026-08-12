# Common Engineering Standards

These rules apply to every project regardless of language or framework.
Bob must follow them in all conversations unless a project-specific rule explicitly overrides one.

---

## Separation of Concerns

- Each file, class, or module has one clearly defined responsibility.
- Do not mix data access, business logic, and presentation in the same unit.
- HTTP/transport concerns (request parsing, response formatting, status codes) belong in the controller or handler layer only — never in services or domain logic.
- Business rules belong in the service or domain layer — never in controllers, repositories, or UI components.
- Data access (queries, persistence, external API calls) belongs in a dedicated repository or client layer.
- When adding to an existing file, check first whether the new logic belongs there or in a different layer.

## Modularity

- Keep functions and methods small — a single function should do one thing and fit within a screen without scrolling.
- Prefer many small, well-named functions over one large function with comments dividing it into sections.
- Extract reusable logic into shared utilities or helper modules rather than duplicating it.
- A module's public interface should be minimal — expose only what callers need.
- Avoid deep nesting (maximum 3 levels of indentation). Flatten with early returns or extracted functions.

## Dependency Injection

- Never instantiate dependencies directly inside a class or function that uses them. Receive them from the outside.
- Dependencies must be injectable — passed via constructor, function parameter, or a DI framework — so they can be replaced in tests.
- Depend on abstractions (interfaces, protocols, abstract classes), not on concrete implementations, wherever the dependency may need to be swapped or mocked.
- Do not use global state, singletons, or static method calls as a substitute for proper injection.
- Configuration values (API keys, URLs, timeouts, feature flags) must come from the environment or a configuration layer — never hardcoded inside logic.

## Testability

- Write code as if it will be unit tested immediately — because it will be.
- A function is testable if it: takes inputs, returns outputs or throws, has no hidden dependencies, and does not read from global state.
- Avoid side effects inside functions that contain logic. Side effects (I/O, logging, database writes) belong at the edges of the system, not buried inside business rules.
- Keep functions pure where possible: same input always produces same output.
- Do not write code that can only be tested by starting the full application.

## Unit Tests

- Every new function, class, or module gets a unit test in the same commit — no exceptions.
- Follow the Arrange–Act–Assert (AAA) pattern. One assertion per test case where practical.
- Name tests descriptively: `test_<function>_<scenario>_<expected_result>` or the language-idiomatic equivalent.
  - Good: `test_calculate_total_with_empty_list_returns_zero`
  - Bad: `test_calculate_total`
- Test the happy path, edge cases (empty, null, zero, max), and error cases (invalid input, thrown exceptions).
- Mock or stub all external dependencies (databases, APIs, file I/O, clocks) — unit tests must run in milliseconds with no network or disk access.
- Do not test implementation details (private methods, internal state). Test observable behaviour through the public interface.
- A failing test is a blocker. Do not leave tests marked as skipped or ignored without a comment explaining why.
- Minimum 70% line coverage for any new code added. Coverage alone is not the goal — meaningful assertions are.

## Makefile

- Every project must have a `Makefile` at the root for common development tasks.
- Use `make` targets as the single entry point for repetitive operations — do not ask the developer to remember long commands.
- Targets must be self-documenting: add a `## description` comment after each target and include a `help` target that prints them.
- Standard targets to include in every project (use language/framework equivalents where needed):

  | Target | Purpose |
  |--------|---------|
  | `make install` | Install all dependencies |
  | `make build` | Compile or build the project |
  | `make test` | Run the full test suite |
  | `make test-unit` | Run unit tests only |
  | `make test-coverage` | Run tests and print coverage report |
  | `make lint` | Run linter / static analysis |
  | `make format` | Auto-format all source files |
  | `make run` | Start the application locally |
  | `make clean` | Remove build artefacts and generated files |
  | `make help` | Print all available targets with descriptions |

- Keep targets simple and composable — `make ci` should call `make lint test build`, not duplicate their logic.
- Use `.PHONY` for all targets that do not produce a file output.
- When Bob generates or modifies build, test, or run commands anywhere in the project, it must also add or update the corresponding `Makefile` target.
- When instructed to run tests, lint, or build, Bob must prefer `make test`, `make lint`, `make build` over direct tool commands, provided the target exists.

## General

- Validate inputs at the boundary of every public function or API endpoint. Fail fast with a clear error message.
- Never swallow exceptions silently. Either handle them with a recovery strategy or let them propagate with added context.
- Log at the appropriate level: DEBUG for internal state, INFO for significant events, WARN for recoverable problems, ERROR for failures requiring attention. Never use print/console.log in production code paths.
- Do not commit commented-out code. Use version control to retrieve old code.
- Do not commit hardcoded credentials, API keys, or secrets of any kind.
- When in doubt between two approaches, prefer the one that is easier to test and easier to change later.
