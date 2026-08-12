# AGENTS.md — Ask mode rules

This file provides guidance to agents when working with code in this repository.

## Understanding this repository

- This is a **documentation-only repository**. There is no source code to analyse, no tests to
  run, and no build to execute.
- The single file `ibm-bob-presentation.md` is a structured presentation covering IBM Bob 2.x
  features. All questions about "how things work here" refer to the content of that file.
- Section numbers are stable. When a user asks "what does §9 cover", read the file — §9 is
  Subagents & Subtasks.
- Lettered subsections (6b, 8b, 11a, 12b) were inserted later without renumbering. They appear
  between their numbered neighbours in the file, not at the end.
- The "Weather API" referenced throughout is a **fictional Spring Boot demo project** used as a
  consistent example thread. It does not exist as actual code in this repository.
- IBM Bob docs are authoritative. When a user asks about a Bob feature not yet in the
  presentation, use `search_bob_docs` to ground the answer before responding.
