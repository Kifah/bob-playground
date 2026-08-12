# AGENTS.md — Plan mode rules

This file provides guidance to agents when working with code in this repository.

## Planning constraints for this repository

- **Only one file to maintain:** `ibm-bob-presentation.md`. Plans that propose splitting it into
  multiple files or converting it to a different format require explicit user approval.
- **Section numbering is frozen at 1–14.** New sections must be inserted as lettered subsections
  (§Nb) or as named `###` subsections inside an existing numbered section.
- **The Weather API demo thread is the anchor.** Any plan to add a new feature section must
  include a concrete Weather API example as part of the plan — not as an afterthought.
- **Two-audience rule is a hard constraint.** Every section plan must account for both:
  - Junior Dev angle: specific commands, file names, keyboard shortcuts, code snippets
  - Project Owner angle: at least one `> 💡 *For Project Owners:*` callout explaining business value
- **ToC is always part of the plan.** Any plan that adds or renames a heading must include the
  ToC update as an explicit step — not implied.
- **Presentation file is not code.** Plans should not propose linting, formatting pipelines,
  CI/CD, or test runners for `.md` files unless the user explicitly asks for that.
