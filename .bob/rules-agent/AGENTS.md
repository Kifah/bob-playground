# AGENTS.md — Agent mode rules

This file provides guidance to agents when working with code in this repository.

## Editing ibm-bob-presentation.md

- **Always use `apply_diff`** for edits — never rewrite the whole file. It is large (~900+ lines)
  and grows with each session.
- **ToC sync is mandatory.** Every heading addition or rename requires a matching ToC update in
  the same `apply_diff` call.
- **Section number stability.** Existing section numbers (1–14) must not be renumbered. Insert
  new content as lettered subsections (e.g. §6b, §6c) or named subsections under an existing §.
- **Weather API thread.** Every feature section must demonstrate the feature through the Weather
  API scenario. Acceptable forms: a prompt block, a config snippet, a `.bob/` file example, or a
  shell script. A conceptual paragraph alone is not sufficient.
- **Demo prompt blocks must be self-contained.** No `...` placeholders, no comments inside the
  fenced block, no instructions mixed into the prompt text. The block should be paste-and-run.
- **Callout types are enforced:**
  - `> 💡` — tips and best practices
  - `> 🎯` — demo-specific presenter tips
  - `> ⚠️` — limitations, warnings, caveats
  Do not invent new callout emoji.
- **YAML indentation is 2 spaces** throughout all code blocks.
- **Shell scripts use `#!/bin/sh`**, not `#!/bin/bash`.
- **File paths in examples** use `.bob/` (project-scoped) unless the example is explicitly about
  global config, in which case use `~/.bob/`.
