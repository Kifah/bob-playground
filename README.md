# IBM Bob 2.0.2 — Playground & Team Presentation

A public reference repository for IBM Bob 2.x — containing a full team presentation, shared global configuration, and engineering standards.

---

## What's in this repo

| Path | What it is |
|---|---|
| [`ibm-bob-presentation.md`](ibm-bob-presentation.md) | Full slide deck for a ~45-min team presentation on IBM Bob 2.0.2 |
| [`bob-config/`](bob-config/) | Shared global Bob configuration — skills, modes, rules |
| [`AGENTS.md`](AGENTS.md) | Project-level rules that govern how Bob edits this repo |
| [`.bob/`](.bob/) | Mode-specific rules for Plan, Agent, and Ask modes |

---

## The Presentation

**[`ibm-bob-presentation.md`](ibm-bob-presentation.md)**

A structured slide deck covering IBM Bob 2.0.2 for an audience of Junior Developers and Project Owners. Includes live demo scripts, copy-paste prompts, and a running Spring Boot Weather API example thread throughout.

### Contents at a glance

| § | Topic |
|---|---|
| [§1 What is IBM Bob?](ibm-bob-presentation.md#1-what-is-ibm-bob) | Capabilities + honest comparison with Copilot agent mode and Claude Code |
| [§2 The Three Modes](ibm-bob-presentation.md#2-the-three-modes) | Plan / Agent / Ask — when and why |
| [§3 Chat Interface & Context Mentions](ibm-bob-presentation.md#3-the-chat-interface--context-mentions) | `@file`, `@problems`, `@terminal`, `@git-changes` |
| [§4 Auto-Approve & Permission Model](ibm-bob-presentation.md#4-auto-approve--permission-model) | Per-action approval, IAM analogy |
| [§5 Literate Coding](ibm-bob-presentation.md#5-literate-coding) | Inline natural-language → code diff |
| [§6 Project Memory](ibm-bob-presentation.md#6-project-memory-init-agentsmd--custom-rules) | `/init`, `AGENTS.md`, custom rules, lifecycle hooks |
| [§7 Slash Commands](ibm-bob-presentation.md#7-slash-commands) | Built-in `/review`, `/init`, custom commands |
| [§8 Todo Tracking & Rollback](ibm-bob-presentation.md#8-todo-tracking--rollback) | Live checklist, one-click rollback |
| [§8b Skills](ibm-bob-presentation.md#8b-skills) | SKILL.md, two-part design, global vs project scope |
| [§9 Subagents & Subtasks](ibm-bob-presentation.md#9-subagents--subtasks) | Background workers, interactive subtasks |
| [§10 Custom Modes](ibm-bob-presentation.md#10-custom-modes) | `custom_modes.yaml`, `fileRegex`, parallel conversation safety |
| [§11 MCP](ibm-bob-presentation.md#11-mcp--extending-bob) | Protocol overview, memory knowledge graph |
| [§12 Demo: Spring Boot Weather API](ibm-bob-presentation.md#12-demo-build-a-spring-boot-weather-api) | 7-part live demo script with narration notes |
| [§12b Prompt Playbook](ibm-bob-presentation.md#12b-ready-to-use-prompt-playbook) | Copy-paste prompts for scaffold, OpenAPI, tests |
| [§13 Tips](ibm-bob-presentation.md#13-tips-for-getting-the-most-from-bob) | Prompt engineering, workflow tips |

---

## bob-config — Shared Global Configuration

**[`bob-config/`](bob-config/)**

A portable set of global Bob skills, modes, and rules that work across all projects and all machines. Clone once, run `install.sh`, and every Bob session inherits the team's shared configuration.

### Quick install

```sh
git clone https://github.com/Kifah/bob-playground ~/dev/bob-playground
cd ~/dev/bob-playground/bob-config
sh install.sh
```

### What gets installed

| Item | Global path | Description |
|---|---|---|
| [`skills/youtube-transcript`](bob-config/skills/youtube-transcript/) | `~/.bob/skills/youtube-transcript` | Extract & summarise any YouTube video |
| [`rules/common-engineering.md`](bob-config/rules/common-engineering.md) | `~/.bob/rules/common-engineering.md` | Language-agnostic engineering standards |
| [`rules/ask-mode.md`](bob-config/rules/ask-mode.md) | `~/.bob/rules/ask-mode.md` | Explanation standards: analogies, Mermaid, tables |
| [`settings/custom_modes.yaml`](bob-config/settings/custom_modes.yaml) | `~/.bob/settings/custom_modes.yaml` | Shared custom modes (placeholder, add your own) |

See **[`bob-config/README.md`](bob-config/README.md)** for full setup instructions and how to add new skills or rules.

---

## Engineering Standards

### [`bob-config/rules/common-engineering.md`](bob-config/rules/common-engineering.md)

Language-agnostic rules Bob follows on every project:

- Separation of concerns — controller / service / repository layers
- Modularity — small functions, no deep nesting, extract over duplicate
- Dependency injection — no direct instantiation, depend on abstractions
- Testability — pure functions, side effects at the edges, no hidden state
- Unit tests — AAA pattern, descriptive names, mock all I/O, 70% coverage floor
- Makefile — every project gets standard `make test`, `make build`, `make run` targets

### [`bob-config/rules/ask-mode.md`](bob-config/rules/ask-mode.md)

Rules for how Bob explains things:

- Analogies from four domains: backend programming, hospital, startup, restaurant
- Mermaid diagrams for sequences, flows, states, and relationships
- Tables for comparisons with ✅ / ❌ / Partial
- 5-step explanation structure: answer → analogy → diagram → technical → when-to-use

---

## Global Skills

### [`youtube-transcript`](bob-config/skills/youtube-transcript/SKILL.md)

Extract and summarise any YouTube video without leaving Bob.

**Requires:** `yt-dlp` — install with `brew install yt-dlp` or `pip install yt-dlp`

**Example prompts:**
```
Summarise this video: https://www.youtube.com/watch?v=vEm9vRFeDis
```
```
Based on this video https://www.youtube.com/watch?v=qdAozfL1mXw,
what gaps do we have in our documentation?
```

---

## Prerequisites for the Demo

- IBM Bob 2.0.2 installed and open in VS Code
- Java 21+ and Maven available in the terminal
- `yt-dlp` for the youtube-transcript skill (`brew install yt-dlp`)

---

## Contributing

To add a new global skill or rule:

1. Add the file under `bob-config/skills/` or `bob-config/rules/`
2. Update [`bob-config/README.md`](bob-config/README.md) with a description
3. Commit and push — teammates run `git pull && sh bob-config/install.sh`

To improve the presentation:

1. Edit [`ibm-bob-presentation.md`](ibm-bob-presentation.md) — follow the conventions in [`AGENTS.md`](AGENTS.md)
2. Keep the Table of Contents in sync with any heading changes
3. Every new feature section needs a Weather API example

---

## License

MIT
