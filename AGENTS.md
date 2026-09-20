# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## What this repository is

A single Markdown presentation file — `ibm-bob-presentation.md` — covering IBM Bob 2.x features
for a mixed Junior Developer / Project Owner audience. There is no source code, build system,
package manager, test runner, or framework.

## Structure of the presentation file

The file is self-contained and structured as numbered top-level sections (§1–§14) with lettered
subsections (§6b, §8b, §11a, §12b). The Table of Contents at the top must be kept in sync with
any heading changes. Section numbers are stable references used in cross-links within the file
(e.g. "see §6").

## Non-obvious conventions

- **All demo prompts** are written as copy-paste-ready fenced code blocks with no surrounding
  commentary inside the block. Keep them clean — no ellipsis, no placeholder text.
- **Pure Java CLI IBAN Checker** is the running demo thread throughout the file. Every new feature section must
  include at least one Pure Java CLI IBAN Checker concrete example (pure Java, CLI execution, length + "DE" check,
  PASS/FAIL output, spaces support as a demo improvement).
- **Section lettering** (6b, 8b, 11a, 12b) indicates a subsection inserted after the numbered
  section without renumbering the rest. New insertions follow this pattern.
- **Callout style**: `> 💡` for tips, `> 🎯` for demo-specific tips, `> ⚠️` for warnings and
  limitations. Do not mix these or use other emoji for callouts.
- **YAML code blocks** use 2-space indentation throughout. Shell scripts use `#!/bin/sh` (not
  `#!/bin/bash`) for portability.
- **File paths** inside examples always use the `.bob/` project-scoped form (never `~/.bob/`)
  unless the example is explicitly about global/personal configuration.

## Audience constraints to maintain

Every section must remain legible to both audiences:
- Junior Devs: need the "how" — concrete commands, file names, keyboard shortcuts
- Project Owners: need the "why" — business value callouts prefixed `> 💡 *For Project Owners:*`

Do not remove PO callouts when editing technical sections.
