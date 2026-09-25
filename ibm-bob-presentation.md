# IBM Bob 2.x — Team Presentation
### "Your AI SDLC Partner in Action"

**Audience:** Developers & Project Owners with decent Gen-AI knowledge  
**Format:** Slides + Live Demo  
**Estimated time:** ~45 min total (25 min slides + 20 min demo)

---

## Table of Contents

1. [What is IBM Bob?](#1-what-is-ibm-bob)
2. [The Three Modes](#2-the-three-modes)
3. [The Chat Interface & Context Mentions](#3-the-chat-interface--context-mentions)
4. [Auto-Approve & Permission Model](#4-auto-approve--permission-model)
5. [Literate Coding](#5-literate-coding)
6. [Project Memory: /init, AGENTS.md & Custom Rules](#6-project-memory-init-agentsmd--custom-rules)
    - [6b. Lifecycle Hooks](#6b-lifecycle-hooks)
7. [Slash Commands](#7-slash-commands)
    - [/review — Built-in Code Review](#review--built-in-code-review-workflow)
8. [Todo Tracking & Rollback](#8-todo-tracking--rollback)
    - [8b. Skills](#8b-skills)
9. [Subagents & Subtasks](#9-subagents--subtasks)
10. [Custom Modes](#10-custom-modes)
11. [MCP — Extending Bob](#11-mcp--extending-bob)
    - [11a. MCP in Practice: The Memory Knowledge Graph](#11a-mcp-in-practice-the-memory-knowledge-graph)
12. [DEMO: Build a Pure Java CLI IBAN Checker](#12-demo-build-a-pure-java-cli-iban-checker)
    - [12b. Ready-to-Use Prompt Playbook](#12b-ready-to-use-prompt-playbook)
13. [Tips for Getting the Most from Bob](#13-tips-for-getting-the-most-from-bob)
14. [Q&A](#14-qa)

---

## 1. What is IBM Bob?

IBM Bob is an **AI SDLC partner** — not just autocomplete, but a full agentic assistant that reasons across your codebase, plans features, implements code across multiple files, and executes terminal commands, all inside your IDE.

> 💡 *If you've used GitHub Copilot or Claude Code, Bob will feel immediately familiar — and then go further.* Copilot's agent mode and Claude Code can both edit files and run terminal commands — so that bar has been raised across the industry. Where Bob goes further is in the **structure** it puts around that power: hard-enforced modes that cap what the AI can do, a persistent memory system that survives across sessions, a skills library your whole team shares, and an approval model that keeps you in control at every step — none of which the other tools offer natively.

**Key differentiators vs. Copilot agent mode and Claude Code:**

| Capability | GitHub Copilot (agent) | Claude Code | IBM Bob |
|---|---|---|---|
| Multi-file edits & terminal commands | ✅ | ✅ | ✅ |
| Reads your actual codebase | ✅ | ✅ | ✅ |
| Hard-enforced tool ceilings per mode | ❌ | Partial (`plan`/`acceptEdits`/`dontAsk` modes exist, but no per-action-type ceiling) | ✅ |
| Persistent project memory | Partial (`.github/copilot-instructions.md`, single file) | Partial (`CLAUDE.md` + `.claude/rules/` directory, similar concept but no mode-specific variants) | ✅ Full layered system with mode-specific rules |
| Structured approval model per action type | Partial (allow/deny per tool via flags, no per-session UI) | Partial (permission modes + `--allow-tool`/`--deny-tool`, no granular per-action-type UI) | ✅ Per-action-type, toggleable in UI |
| Team-shareable skills library | ❌ | ❌ | ✅ |
| Subagents + subtasks as first-class primitives | Partial (Cloud Agent opens PRs autonomously; no subtask UI concept) | Partial (subagents only, no subtask breadcrumb UI) | ✅ |
| MCP server integration | ✅ | ✅ | ✅ |
| Fixed 270,000-token context window | ❌ (varies by model/plan) | ❌ (varies by model/plan) | ✅ |

> 💡 *For Project Owners:* Think of Bob as an autonomous junior developer you can pair with any engineer, that never loses context about your project conventions, always asks before making changes, and can be rolled back instantly.

---

## 2. The Three Modes

Bob ships with three **purpose-built modes**. Each mode restricts Bob to a specific set of tools, keeping its behaviour predictable and safe.

> 💡 *Familiar concept:* Think of modes like **database transaction isolation levels** — each one draws a boundary around what can be seen and changed. Agent mode is `READ WRITE` (full access). Ask mode is `READ ONLY` (no side effects). Plan mode is somewhere in between. Claude Code has a similar concept (`plan` mode, `acceptEdits` mode), but in Bob the boundaries are defined per-mode by an explicit tool list — not a flag you pass at startup — making them composable, team-shareable, and version-controlled in `.bob/custom_modes.yaml`.

| Mode | Purpose | Tools available | When to use |
|------|---------|-----------------|-------------|
| **Plan** | Architecture & design | Read, Edit, MCP, Skill, Subagent, Mode | Before writing code — design phase |
| **Agent** | Write, edit & run code | Full access (Read, Edit, Execute, MCP, Skill, Todo, Subtask, Subagent, Mode) | Day-to-day implementation & debugging |
| **Ask** | Q&A and analysis | Read, MCP, Skill, Subagent (explore only), Mode | Understanding code, no changes needed |

**Recommended workflow:**
```
Plan mode → review the plan → Agent mode → implement → Ask mode → understand what was built
```

> 💡 Switch modes with `/plan`, `/agent`, `/ask` or the mode picker at the bottom of the sidebar.

### Modes in the Pure Java IBAN Checker context

Here is how you would use each mode as the IBAN Checker CLI tool is designed, built, and tested:

| Stage | Mode | Example prompt |
|-------|------|---------------|
| Design CLI logic & rules | **Plan** | *"Plan how to build a pure Java CLI application that validates German IBANs (starts with DE, length 22) and outputs PASS or FAIL."* |
| Implement CLI validator | **Agent** | *"Implement the plan. Add IbanChecker.java with validate() method and main(String[] args), plus JUnit 5 tests."* |
| Understand what was built | **Ask** | *"@/src/main/java/com/example/iban/IbanChecker.java — explain how whitespace is stripped and how the CLI arguments are handled."* |
| Add packaging / fat JAR | **Agent** | *"Configure maven-shade-plugin in pom.xml to build an executable CLI JAR with mainClass com.example.iban.IbanChecker."* |
| Add benchmark / performance | **Agent** | *"Add a JMH benchmark to measure validation throughput of 1,000,000 IBAN checks in pure Java."* |
| Review before a commit | **Ask** | *"@/src/main/java/com/example/iban/IbanChecker.java — review the implementation for edge cases like null, empty strings, and performance."* |

---

## 3. The Chat Interface & Context Mentions

The **agentic chat sidebar** is Bob's primary workspace. It lets you write natural language requests, reference specific files or errors using **context mentions**, and watch Bob's step-by-step reasoning in real time.

### Context Mention types

| Syntax | What it injects |
|--------|----------------|
| `@/src/IbanChecker.java` | Full file contents |
| `@/src/com/example/iban` | All files in that folder (non-recursive) |
| `@problems` | Current errors & warnings from the Problems panel |
| `@terminal` | Recent terminal output |
| `@git-changes` | Uncommitted diff |
| `@a1b2c3d` | A specific git commit diff |
| `@https://...` | Content from a URL |

**Shortcut:** Highlight any code in the editor → `Cmd+L` (Mac) / `Ctrl+L` (Win/Linux) → instantly sends it to chat.

> 💡 Combine multiple mentions: *"Fix `@problems` in `@/src/com/example/iban/IbanChecker.java`"*

---

## 4. Auto-Approve & Permission Model

Every action Bob wants to take is presented for your approval. You can configure **auto-approve** per action type to speed up trusted workflows.

> 💡 *Familiar concept:* This is **IAM / RBAC** for your AI session — the same mental model as AWS IAM roles or Kubernetes RBAC. Each action type (Read, Edit, Execute, MCP…) is a permission. Auto-approving it is like granting a role to a service account: convenient, but sized to the principle of least privilege. Keep the high-risk ones (Edit, Execute) on manual until you trust the workflow.

| Action | Risk level | What it allows |
|--------|------------|----------------|
| Read | Medium | View files & directories |
| Edit | **High** | Create, edit, save files |
| Execute | **High** | Run terminal commands |
| MCP | Medium-High | Use configured MCP servers |
| Skill | Medium | Activate defined skills |
| Todo | Low | Update the task checklist |
| Subtask | Low | Create & complete subtasks |
| Subagent | Low | Spawn background agents |
| Mode | Low | Switch modes |

> 🎯 **Demo tip:** Keep **Edit** and **Execute** on manual approval — the audience sees every proposed change before it lands.

---

## 5. Literate Coding

Write instructions **directly in your editor** in plain language — Bob converts them to real code inline.

> 💡 *Familiar concept:* Think of it as **Javadoc or JSDoc taken one step further** — instead of writing a comment that describes what the code does, you write the intent and Bob writes the code. If you've used Copilot's inline suggestions, the feel is similar: you're in the editor, the suggestion appears inline. The difference is you initiate it deliberately, and you review a full file diff before anything is saved.

**How it works:**
1. Open a file in the editor
2. Press `Cmd+I` (Mac) / `Ctrl+I` (Win/Linux) — or click the magic wand icon
3. Type a natural language instruction where the code should go (text appears in **blue**)
4. Press `Cmd+Enter` — Bob generates a diff inline
5. Accept (`Cmd+Enter`) or reject (`Cmd+Shift+Backspace`)

**Best for:**
- Adding wrapper logic (retry, error handling, logging)
- Targeted refactoring of a specific block
- Quick, precise changes without opening chat

**Not ideal for:** Multi-file changes — use Agent mode chat for those.

> 💡 *Demo impact:* The blue instruction text turning into a green/red diff is immediately clear to any audience.

---

## 6. Project Memory: /init, AGENTS.md & Custom Rules

LLMs are stateless — each new conversation starts from scratch. Bob solves this through a layered rules system that persists context across sessions.

Bob has three mechanisms for injecting persistent context — they all add text to the conversation without you typing it manually, but differ in *when* and *how* they activate:

```mermaid
flowchart LR
    R["📋 Rules\n(AGENTS.md / rules/)"]
    M["🔀 Modes\n(custom_modes.yaml)"]
    S["🎯 Skills\n(.bob/skills/)"]

    R --> RA["always active\n— every conversation"]
    M --> MA["activated by user\n— explicit mode switch"]
    S --> SA["activated by Bob\n— on demand when task matches"]

    style R  fill:#1e3a5f,color:#fff,stroke:#3b82d4
    style M  fill:#1e3a5f,color:#fff,stroke:#3b82d4
    style S  fill:#1e3a5f,color:#fff,stroke:#3b82d4
    style RA fill:#0f2a1f,color:#d1fae5,stroke:#22c55e
    style MA fill:#2a1f0f,color:#fef9c3,stroke:#eab308
    style SA fill:#2a0f2a,color:#f3e8ff,stroke:#a855f7
```

### /init & AGENTS.md

> 💡 *Familiar concept:* If you've used GitHub Copilot's `.github/copilot-instructions.md` or Claude Code's `CLAUDE.md`, `AGENTS.md` is exactly that idea — a markdown file committed to the repo that tells the AI about your project conventions. Bob takes it further: `/init` generates it automatically by scanning the codebase, and creates **mode-specific variants** so Plan mode and Agent mode each get their own tailored context file. Neither Copilot nor Claude Code have mode-scoped rule files — they load a single instructions file for every session.

**What `/init` does:**
- Scans your project structure, tech stack, and conventions
- Generates a root-level `AGENTS.md` — Bob reads this at the start of every conversation
- Creates mode-specific files in `.bob/` for Plan, Agent, and Ask modes

**`AGENTS.md` typically includes:**
- Project overview and purpose
- Directory structure and key file locations
- Technology stack and dependencies
- Architectural patterns and coding conventions
- Development workflows

**Re-run `/init` when:**
- Adding new modules or services
- Changing directory structure
- Onboarding new team members to Bob

> 💡 *For Project Owners:* Manually add business rules, deployment conventions, and team practices to `AGENTS.md` — things Bob's scan can't auto-detect.

### Custom Rules

**Custom rules** are the broader system `AGENTS.md` lives inside. They let you shape Bob's coding style, documentation standards, testing methodology, and decision-making — persistently, without repeating yourself in every prompt.

> 💡 *Familiar concept:* Custom rules are **ESLint / Checkstyle config for Bob's behaviour** — the same idea as a linter ruleset, but instead of enforcing code style at save time, they enforce how the AI reasons and responds. Just as `.eslintrc` or `checkstyle.xml` is committed to the repo so every developer gets the same rules, `.bob/rules/` is committed so every Bob session on the project gets the same guidelines.

**Two scopes:**

| Scope | Location | Applies to |
|-------|----------|-----------|
| **Global** | `~/.bob/rules/` (Linux/Mac) or `%USERPROFILE%\.bob\rules\` (Windows) | All projects on your machine |
| **Workspace** | `.bob/rules/` in your project root | This project only |

Workspace rules override global rules when both exist. Within each scope, mode-specific rules load before general rules.

**Directory structure:**

```
.bob/
├── rules/              ← applies to all modes in this project
├── rules-agent/        ← Agent mode only
├── rules-plan/         ← Plan mode only
├── rules-ask/          ← Ask mode only
└── rules-{custom-slug}/← any custom mode (e.g. rules-devops/)
```

Files load in **alphabetical order** and are combined with any `customInstructions` set in `custom_modes.yaml`. Empty files, cache files, and `.DS_Store` are silently skipped.

**Rule priority (highest to lowest):**
1. Mode-specific workspace rules (`.bob/rules-agent/`)
2. General workspace rules (`.bob/rules/`)
3. Mode-specific global rules (`~/.bob/rules-agent/`)
4. General global rules (`~/.bob/rules/`)

> ⚠️ **Keep rules files short.** Rules are injected into every conversation — a 150-line rules file costs roughly 2,700 tokens of your 270,000-token context window. Every token spent on standing rules is a token not available for your code. Put only what you truly need in every conversation; anything task-specific belongs in a skill instead. You can hover over the rules indicator in the Bob sidebar to see exactly how many tokens your current rules file is consuming.

---

**IBAN Checker CLI — practical rules setup:**

Create the rules directories and seed them:
```bash
mkdir -p .bob/rules .bob/rules-agent .bob/rules-ask
```

`.bob/rules/coding-style.md` — applies to all modes:
```markdown
# IBAN Checker — Coding Standards

## Pure Java & CLI Rules
- Pure standard Java only (no Spring Boot, no external framework dependencies)
- German IBAN validation rule: starts with "DE" and exact length is 22 characters (whitespace stripped during formatting improvements)
- CLI output contract: print "PASS" or "FAIL" on stdout (never System.exit(1) or usage error on stderr)
- Provide a Makefile with `make build`, `make test`, and `make run IBAN="..."`
- Keep functions small, static, and testable without side effects
- All public methods must have Javadoc
```

`.bob/rules-agent/testing.md` — applies only in Agent mode:
```markdown
# Testing Rules (Agent mode)

- Always write unit tests with JUnit 5 (junit-jupiter)
- Test both positive (PASS) and negative (FAIL) scenarios
- Cover nulls, empty strings, whitespace variations, wrong country prefixes, and incorrect lengths
- Test method names follow: should_<expectedBehaviour>_when_<condition>
```

`.bob/rules-ask/review.md` — applies only in Ask mode:
```markdown
# Review Rules (Ask mode)

When reviewing code, always structure the response as:
1. Summary of what the code does
2. Issues found (severity: HIGH / MEDIUM / LOW, with file and line number)
3. Suggestions (optional — only if explicitly asked)
Never modify files in Ask mode.
```

**Team standardisation — commit everything:**
```bash
git add .bob/rules/ .bob/rules-agent/ .bob/rules-ask/
git commit -m "Add Bob custom rules for IBAN Checker"
```

> 💡 *Writing effective rules — three principles:*
> - **Be specific:** "Use 4 spaces for indentation in Java files" beats "format code nicely"
> - **Be actionable:** Rules should constrain a decision, not describe an aspiration
> - **Organise by topic:** One file per concern (coding-style, testing, documentation) makes rules easy to update

---

## 6b. Lifecycle Hooks

**Lifecycle hooks** let you run shell commands automatically at specific points in a Bob session — to log activity, inject context into the model, gate or block actions, or trigger follow-up automation. No Bob modifications required.

> 💡 *If you know Git hooks, this will feel familiar.* Both intercept actions at defined points and can block them by exiting with a non-zero code. The key difference: **Git hooks guard your repository** — they fire when code is committed or pushed, regardless of what triggered the change. **Bob hooks guard your AI session** — they fire when Bob is about to act (read a file, write a file, run a command), before Git is ever involved. They complement each other: Bob hooks catch things at the AI layer, Git hooks catch the same code again at the commit layer.

### Supported hooks

| Hook | When it runs | Blocking | Stdout behaviour |
|------|-------------|----------|-----------------|
| `SessionStart` | Once when a session begins | No | Injected as model context |
| `UserPromptSubmit` | Each time you submit a prompt | Yes (exit `2`) | Injected alongside the prompt |
| `PreToolUse` | Before a matched tool runs | Yes (exit `2`) | Ignored |
| `PostToolUse` | After a matched tool completes | No | Ignored |
| `Stop` | When the agent stops | No | Ignored |

Only `UserPromptSubmit` and `PreToolUse` can **block** an action. Exiting with code `2` from either will stop the prompt or tool from proceeding. Exit `2` from any other hook is logged and ignored.

### Configuration

Hooks are defined under the `hooks` key in `settings.json`. Bob merges from two locations:

| Scope | File |
|-------|------|
| Global (all workspaces) | `~/.bob/settings/settings.json` |
| Workspace (this project) | `.bob/settings.json` |

Global hooks always run. Workspace hooks are merged on top and apply only to the current project.

**Schema:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^write_file$",
        "hooks": [
          {
            "type": "command",
            "command": "sh .bob/hooks/check.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

`matcher` is a regex matched against the tool name (`PreToolUse` / `PostToolUse` only). Omit it to match all tools. `timeout` defaults to 10 seconds; set to `0` to disable.

---

### IBAN Checker CLI — four practical hook examples

**1. `SessionStart` — inject live project context into every session**

Automatically tells Bob what branch you're on and the Java environment — without you typing it:

`.bob/hooks/session-context.sh`:
```bash
#!/bin/sh
echo "Project: Pure Java CLI IBAN Checker (Maven)"
echo "Git branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
echo "Java version: $(java -version 2>&1 | head -1)"
```

`.bob/settings.json`:
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/session-context.sh" }]
      }
    ]
  }
}
```

Bob receives this as context at session start — it knows the branch and whether the running instance is healthy before you type your first prompt.

---

**2. `PreToolUse` — block writes outside `src/` to protect the project structure**

Prevents Bob from accidentally writing files to the project root or unintended directories:

`.bob/hooks/guard-src.sh`:
```bash
#!/bin/sh
PATH_VAL=$(cat | python3 -c "import sys,json; print(json.load(sys.stdin)['input'].get('path',''))")
case "$PATH_VAL" in
  src/*|.bob/*|test/*)
    exit 0
    ;;
  *)
    echo "Blocked: writes outside src/, .bob/, or test/ are not permitted" >&2
    exit 2
    ;;
esac
```

`.bob/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^write_file$",
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/guard-src.sh", "timeout": 5 }]
      }
    ]
  }
}
```

Bob attempts to write a file → hook reads the `input.path` → if it's outside allowed directories, exit `2` blocks the write and Bob reports the tool as blocked.

---

**3. `PostToolUse` — auto-run tests after every file write**

Every time Bob writes a Java file, the test suite runs immediately so you see failures before the next step:

`.bob/hooks/run-tests-on-write.sh`:
```bash
#!/bin/sh
PATH_VAL=$(cat | python3 -c "import sys,json; print(json.load(sys.stdin)['input'].get('path',''))")
case "$PATH_VAL" in
  src/main/java/*)
    echo "Java source changed — running tests..." >&2
    mvn test -q --no-transfer-progress 2>&1 | tail -20 >&2
    ;;
esac
```

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "^write_file$",
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/run-tests-on-write.sh", "timeout": 60 }]
      }
    ]
  }
}
```

> ⚠️ `PostToolUse` is non-blocking. Test failures are logged but will not stop Bob from continuing. Use this for visibility, not gating.

---

**4. `Stop` — auto-commit staged changes when Bob finishes a session**

When Bob completes a scaffolding or refactoring session, any staged changes are committed automatically with a timestamped message:

`.bob/hooks/auto-commit.sh`:
```bash
#!/bin/sh
cd "$PWD"
if ! git diff --cached --quiet; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git commit -m "chore(bob): auto-commit from Bob session on ${BRANCH} at $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo "Auto-committed staged changes." >&2
fi
```

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/auto-commit.sh" }]
      }
    ]
  }
}
```

---

**Complete `.bob/settings.json` for the IBAN Checker API — all four hooks combined:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/session-context.sh" }]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "^write_file$",
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/guard-src.sh", "timeout": 5 }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "^write_file$",
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/run-tests-on-write.sh", "timeout": 60 }]
      }
    ],
    "Stop": [
      {
        "hooks": [{ "type": "command", "command": "sh .bob/hooks/auto-commit.sh" }]
      }
    ]
  }
}
```

**Project structure after adding hooks:**
```
.bob/
├── settings.json          ← hook configuration
├── hooks/
│   ├── session-context.sh ← SessionStart: inject branch + health
│   ├── guard-src.sh       ← PreToolUse:   block writes outside src/
│   ├── run-tests-on-write.sh ← PostToolUse: run mvn test after writes
│   └── auto-commit.sh     ← Stop:         commit staged changes
├── rules/
│   └── coding-style.md
├── rules-agent/
│   └── testing.md
└── agents/
    ├── pr-summarizer.md
    └── code-reviewer.md
```

> 💡 *For teams:* Commit `.bob/hooks/` and `.bob/settings.json` to version control alongside your other `.bob/` config. Every team member gets the same session guards and automation immediately on clone.

> ⚠️ *Current limitations:* Only `command` hooks are supported. Hooks cannot rewrite prompt or tool input before it reaches the model. Hooks run with your full user permissions — no sandboxing is applied.

---

## 7. Slash Commands

Slash commands let you trigger actions, switch modes, and run **custom reusable prompts** without re-typing instructions.

> 💡 *Familiar concept:* Slash commands are **npm scripts for your AI workflows** — named shortcuts that wrap a repeatable action. If you've built up a library of prompts in Claude or ChatGPT that you copy-paste every session, slash commands are the equivalent committed to the repo: versioned, shared with the team, and available on clone with no setup.

### Built-in commands

| Command | Effect |
|---------|--------|
| `/init` | Generate `AGENTS.md` for the project |
| `/agent`, `/plan`, `/ask` | Switch modes instantly |
| `/review` | AI-powered code review — see below |
| `/permissions` | Check and change the workspace trust level |

### `/review` — built-in code review workflow

`/review` opens a dedicated **Review panel** in the sidebar. Bob diffs your selected branches, runs automated analysis, and surfaces findings in the **Bob Findings panel** — all with auto-approval (no manual confirmation needed per step).

**Usage variants:**

| Command | What it reviews |
|---------|----------------|
| `/review` | Local uncommitted changes in the working directory |
| `/review <branch>` | Diff between `<branch>` and your current HEAD |
| `/review #<issue>` `--issue-coverage` | Validates local changes actually address a GitHub issue |
| `/review <issue-url>` `--issue-coverage` | Same, using a full GitHub issue URL |

**What Bob analyses:** bug detection, security issues, performance problems, style consistency.

**How to use the Review panel:**
1. Run `/review` — the Review panel opens in the sidebar
2. Select the branch to compare against (local, remote, or repo default)
3. Toggle **Include Uncommitted Changes** if needed
4. Optionally link a GitHub issue to validate coverage
5. Click **Start Review** — findings appear in the Bob Findings panel

> 💡 *For Project Owners:* Use `/review #<issue>` `--issue-coverage` before raising a PR to verify that the implementation actually addresses the ticket requirements — not just that it compiles and passes tests.

> ⚠️ Branch comparisons work with both GitHub and GitLab. Issue validation (`--issue-coverage`) requires a GitHub account and issue URL.

**IBAN Checker CLI — practical use:**
```
/review main --issue-coverage
```
Run this before every PR on the IBAN Checker to catch bugs, validation edge cases in `IbanChecker`, and verify that the implementation addresses the linked ticket.

---

### Creating custom commands

Create a markdown file in `.bob/commands/` — the filename becomes the command:

```
.bob/commands/
├── test-cli.md       →  /test-cli
└── security-check.md →  /security-check
```

> ⚠️ Do not name a custom command file `review.md` — `/review` is a built-in command and cannot be overridden by a custom command file.

Example `.bob/commands/test-cli.md`:
```markdown
Run the full IBAN Checker test suite and report:
1. Which tests passed and which failed
2. Code coverage percentage for IbanChecker
3. Any test that took longer than 500ms
```

> 💡 *For teams:* Commit `.bob/commands/` — every team member gets the same standardised prompts, version-controlled with the project.

---

## 8. Todo Tracking & Rollback

### Todo Tracking

For complex multi-step tasks, Bob maintains a **live checklist** in the UI:

> 💡 *Familiar concept:* The todo list looks and feels like a **GitHub Actions workflow run** — each step goes from pending → in progress → complete and you can see exactly where Bob is. The difference: you can intervene between steps, approving or rejecting each action before it executes.
- Items marked complete as work progresses
- Newly discovered steps added dynamically
- Only one item "in progress" at a time
- Clear view of what's done and what remains

**What the todo list looks like mid-task** — after asking Bob to scaffold the pure Java CLI IBAN Checker and add tests:

```
[ ] Create Maven project structure
[x] Generate minimal pom.xml with junit-jupiter
[x] Create IbanChecker.java with validate() method
[-] Implement main(String[] args) with PASS/FAIL CLI output  ← in progress
[ ] Create IbanCheckerTest.java covering valid, invalid, and null inputs
[ ] Verify compilation and test suite execution
```

**IBAN Checker CLI — todo-worthy prompts** (tasks complex enough that Bob will auto-generate a todo list):

```
Build a pure Java CLI IBAN Checker:
- Implement IbanChecker.java with validate(String iban) method
- Strip all whitespace and check that it starts with "DE" and has exact length of 22
- Main method prints "PASS" or "FAIL" to stdout
- Add comprehensive JUnit 5 unit tests covering all edge cases
```

```
Package the IBAN Checker as a standalone CLI tool:
- Configure maven-shade-plugin or maven-assembly-plugin to produce a runnable fat JAR
- Add a shell wrapper script bin/iban-check for easy terminal execution
- Add automated end-to-end CLI assertion tests in bash
```

### Rollback

Bob uses Git under the hood. Every prompt in the chat history has a **Rollback** button:

> 💡 *Familiar concept:* Rollback is `git reset --hard` without the ceremony. Every prompt in the chat is a named restore point — hover, click, files restored. No branch-switching, no stash, no hunting through history. It's the safety net that makes experimentation with AI changes genuinely low-risk.

1. Hover over any prompt in the chat
2. Click **Rollback** → files restored to exactly that point in time
3. No manual Git commands needed

> 💡 *Pro tip:* If Bob starts producing subpar output, rollback is more effective than trying to correct it with new prompts — it resets the files *and* clears the bad context.

---

## 8b. Skills

Skills are reusable instruction sets that Bob loads on demand into its context — like a specialised playbook for a specific task type. They are defined as `SKILL.md` files and activated with the `use_skill` tool or via a slash command.

**How a skill is stored in context — the two-part design:**

Every skill has two parts that are treated very differently by Bob:

| Part | What it is | When it is loaded |
|------|-----------|-------------------|
| **`description:`** (1–2 sentences in the frontmatter) | A short signal Bob uses to decide if this skill is relevant | **Always** — added to every conversation alongside rules |
| **Body** (everything below the `---` delimiter) | The full instructions, checklist, workflow, or reference material | **On demand only** — loaded into context when Bob activates the skill |

This design is deliberate: loading every skill's full body into every conversation would waste thousands of tokens. Only the tiny description is always present; the body is pulled in only when needed. The result is a large library of skills with near-zero standing token cost.

> 💡 *Familiar concept:* Skills are **middleware or interceptors** that you opt into for a specific request. Like a Spring `HandlerInterceptor` or an Express middleware that enriches a request with extra context before the handler runs — a skill enriches Bob's context with domain-specific instructions before it tackles a task. It's loaded on demand, scoped to that task, and unloaded when done.

**How skills differ from slash commands:**

| | Slash command | Skill |
|--|---------------|-------|
| **What it is** | A prompt template (plain text) | A structured instruction set with metadata |
| **Loaded when** | Invoked with `/command` | Activated by Bob when task matches, or explicitly requested |
| **Scope** | Runs once as a prompt | Stays in context for the duration of the task |
| **Best for** | Repeatable one-shot prompts | Complex multi-step workflows that need persistent instructions |

**Skill file location:**
```
.bob/skills/
├── pure-java-test-writer/SKILL.md    ← project-scoped
└── cli-packager/SKILL.md

~/.bob/skills/
└── security-reviewer/SKILL.md        ← global (available in all projects)
```

**Example: a `pure-java-test-writer` skill for the IBAN Checker project**

`.bob/skills/pure-java-test-writer/SKILL.md`:
```markdown
---
name: pure-java-test-writer
description: Writes comprehensive JUnit 5 unit tests for pure Java CLI and utility classes.
---

When writing tests for this project, always:
- Use JUnit 5 Jupiter (`org.junit.jupiter.api.Test`, `ParameterizedTest`, `ValueSource`)
- Name test classes: `<ClassName>Test.java`
- Place all test files under `src/test/java` mirroring the main package structure
- Cover happy paths, edge cases (whitespace, lowercase/uppercase, boundaries), and null inputs
- Test CLI `main(String[] args)` behavior and exit codes / stdout output
- Add a `@DisplayName` on every `@Test` method describing the scenario in plain English
```

**Activating the skill in chat:**
```
Use the pure-java-test-writer skill.
Write tests for IbanChecker covering:
- Valid German IBAN with exact 22 chars and DE prefix -> PASS
- Valid German IBAN containing internal whitespace -> PASS
- Invalid country prefix (e.g. FR, GB) -> FAIL
- Invalid length (<22 or >22) -> FAIL
- Null or empty input -> FAIL
```

**Another example: a `cli-packager` skill**

`.bob/skills/cli-packager/SKILL.md`:
```markdown
---
name: cli-packager
description: Packages pure Java applications into standalone executable CLI JARs using Maven plugins.
---

When configuring standalone CLI packaging:
- Use maven-shade-plugin or maven-assembly-plugin in pom.xml
- Set the mainClass to the application entry point (e.g. com.example.iban.IbanChecker)
- Configure executable JAR output in the target/ directory
- Generate a companion shell wrapper script in bin/
- Document copy-paste CLI execution commands
```

> 💡 *Team use case:* Commit skills to `.bob/skills/` so every developer on the team benefits from the same accumulated best practices — without having to re-explain them in every prompt.

---

## 9. Subagents & Subtasks

Two mechanisms for handling complex or parallel work — they look similar but serve different purposes.

### Subagents (background, silent)

Bob spawns a subagent when a task is clearly self-contained, would generate large noise in the main context, and cannot be done in 1–2 direct tool calls.

> 💡 *Familiar concept:* Subagents work like **async background workers** — the same pattern as a Kafka consumer or a Celery task. The main process hands off a self-contained job, the worker runs in its own isolated context, and when it's done it posts a result back. You never see the worker's internal steps — only the summary that matters. This keeps the main conversation lean and focused, no matter how much exploration the subagent does internally.

| Type | Model | Tools | Use case |
|------|-------|-------|----------|
| `explore` | Lighter | Read-only | Codebase research & mapping |
| `general` | Full | Full access | Complex isolated work |

- Run **silently** in their own context window
- Return only a **summary** to the main conversation
- You **approve the spawn** before it starts
- `fork_context: true` passes parent conversation history if needed

**IBAN Checker CLI — subagent scenario:**

You've asked Bob to optimise the pure Java IBAN validation logic. Before writing a single line of code, Bob needs to explore the current project structure: what classes exist, how the validation is implemented, and what test coverage exists.

That exploration would generate unnecessary noise in your main context. Instead, Bob spawns an `explore` subagent:

```
Bob spawns subagent (explore):
  "Map the current IBAN Checker project. For each Java file, summarise:
   - Its role (CLI entry point / validator / test)
   - What methods exist and their validation logic
   - Test cases already covered
   Return a structured summary only."
```

The subagent runs silently and returns:
```
Summary returned to parent:
  - IbanChecker.java     → contains validate(String) & main(String[] args), prints PASS/FAIL
  - IbanCheckerTest.java → JUnit 5 tests covering happy path and edge cases
  - Zero external framework dependencies; pure standard Java 21
```

Bob now has exactly what it needs — and your main context is clean for the actual implementation.

**When Bob will NOT use a subagent** on the IBAN Checker:
- You ask it to adjust the regex or length in `IbanChecker.java` → 1 direct tool call, no subagent
- You ask it to explain `IbanChecker.java` → 1 `read_file` call, no subagent
- You ask it to fix a compilation error shown in `@problems` → already has context, no subagent

### Subtasks (visible, interactive)

Bob creates a subtask for work that benefits from its own breadcrumb and conversation thread in the UI, step-by-step visibility, and a dedicated todo list.

> 💡 *Familiar concept:* Subtasks are **Git branches for conversations** — you open a new branch for a self-contained feature so it doesn't pollute `main`; Bob opens a new conversation thread with its own breadcrumb and todo list so the work doesn't pollute the main chat. When the subtask is done, the result comes back as a summary — like a PR merge, but for context.

**IBAN Checker CLI — subtask scenario:**

You're adding native GraalVM packaging and a cross-platform CLI installer for the IBAN Checker. This is a distinct piece of work that deserves its own conversation thread and dedicated todo list.

**Prompt that triggers a subtask:**
```
Create a subtask to configure GraalVM Native Image compilation for the IBAN Checker.

Requirements:
- Add native-maven-plugin to pom.xml
- Configure mainClass com.example.iban.IbanChecker
- Add a GitHub Actions workflow to build native binaries for macOS, Linux, and Windows
- Ensure the compiled binary runs instantly (<10ms) and outputs PASS or FAIL
```

What you see in the UI:
```
Main conversation  ──→  "IBAN Checker — GraalVM Native CLI"  [breadcrumb]
                              ↓
                         Plan mode: native-maven-plugin configuration designed
                              ↓
                         Agent mode: pom.xml updated, .github/workflows/native.yml created
                              ↓
                         Todo list tracking each configuration step
                              ↓
                         Summary returned to main conversation
```

> 💡 *Rule of thumb:* Subagent = silent helper that reports back. Subtask = a mini project you can watch, interact with, and navigate to independently in the UI.

---

## 10. Custom Modes

Create modes tailored to specific workflows, restricting Bob to exactly the tools and behaviour you want.

> 💡 *Familiar concept:* Custom modes are **Spring Security filter chains** or **Express router middleware stacks** — you define exactly which capabilities are available in that context, in what order, and with what constraints. A read-only `security-reviewer` mode is like a filter chain that passes every request through a read-only interceptor and throws a 403 on any write attempt. The `fileRegex` on the edit group is like a route matcher — edits are only allowed if the path matches.

**Configured via `.bob/custom_modes.yaml` (project) or `~/.bob/settings/custom_modes.yaml` (global).**

You can also **override built-in modes** by using the same slug (`ask`, `agent`, `plan`).

> 💡 **Parallel conversations safety.** When running multiple Bob conversations at the same time — a common pattern when exploring one thing while implementing another — activating a read-only mode in the exploratory conversation guarantees it cannot edit any files, no matter what you ask. This is a hard enforcement: the edit tool is simply not in the mode's tool list. Instructions alone cannot override it. Use this any time you want information without any risk of accidental changes landing in your working tree.

> 💡 Custom modes and custom rules work together. A mode's `customInstructions` field in YAML is the inline equivalent of a rules file — but for larger or team-shared rule sets, prefer a dedicated file in `.bob/rules-{mode-slug}/` (see §6). Files in that directory are loaded alongside `customInstructions`, in alphabetical order.

### Custom modes for the IBAN Checker CLI project

Here are custom modes you would realistically commit to `.bob/custom_modes.yaml` as the IBAN Checker tool evolves:

**1. Code Quality Reviewer** — read-only, safe to run on any branch, zero edit risk:
```yaml
customModes:
  - slug: quality-reviewer
    name: 🔒 Quality Reviewer
    description: Reviews pure Java code for algorithmic correctness, null safety, and performance.
    roleDefinition: >
      You are a senior Java engineer specialising in pure Java utility libraries and CLI tools.
      Review code for boundary conditions, sanitisation, performance, and memory efficiency. Never modify files.
    whenToUse: Use before merging any PR or commit touching validation logic.
    customInstructions: |
      Focus on: null/empty edge cases, Unicode whitespace handling, string allocations,
      and clean JUnit 5 test coverage. Report findings as a numbered list with suggested fixes.
    groups:
      - read
      - mcp
```

**2. Pure Java Test Specialist** — edits Java test files only, cannot touch production logic:
```yaml
  - slug: test-writer
    name: 🧪 Test Specialist
    description: Writes JUnit 5 tests for pure Java classes. Test files only.
    roleDefinition: >
      You are a QA automation specialist specialising in JUnit 5 unit tests for pure Java applications.
    whenToUse: Use when writing or expanding test suites.
    customInstructions: |
      - Use JUnit 5 Jupiter assertions and parameterized tests
      - Always cover happy paths, boundary lengths, invalid prefixes, and malformed strings
    groups:
      - read
      - - edit
        - fileRegex: "src/test/java/.*\\.java$"
          description: Java test files only
      - execute
      - skill
```

**3. CLI & Packaging Specialist** — edits build and packaging files only:
```yaml
  - slug: packaging-dev
    name: 📦 Packaging Specialist
    description: Manages pom.xml, fat JAR packaging, shell wrappers, and GitHub Actions.
    roleDefinition: >
      You are a build engineer specialising in Maven packaging, CLI distributions, and GraalVM native binaries.
    whenToUse: Use for build configuration, packaging, and release automation.
    customInstructions: |
      - Configure maven-shade-plugin or native-maven-plugin for CLI distribution
      - Ensure executable binaries run with zero external runtime dependencies
    groups:
      - read
      - - edit
        - fileRegex: "pom\\.xml|\\.github/.*|bin/.*"
          description: Build and release files only
      - execute
      - mcp
```

> 💡 These custom modes can be committed to `.bob/custom_modes.yaml` together. They appear in Bob's mode picker and as slash commands (`/quality-reviewer`, `/test-writer`, `/packaging-dev`) immediately after committing the file.

---

## 11. MCP — Extending Bob

**Model Context Protocol (MCP)** is a standardised protocol that connects Bob to external tools and services, going far beyond what's built in.

> 💡 *Familiar concept:* MCP is **JDBC for AI tools** — a standardised adapter protocol. Just as JDBC lets your Java app talk to any database without caring if it's PostgreSQL or MySQL, MCP lets Bob talk to any external tool without bespoke integration code. You write the MCP server once; it works with any MCP-compatible AI client. Think of each MCP server as a database driver you can swap in or out.

**Examples of what MCP enables:**
- Query a live database and reason over the results
- Integrate with Monday.com, Jira, or internal ticketing systems
- Access your organisation's internal knowledge bases
- Connect to deployment tools, monitoring systems, and infrastructure APIs

**MCP servers can be:**
- Local (run on your machine, STDIO transport)
- Remote (hosted services, SSE transport)

**Each MCP tool can be individually enabled/disabled** to keep context consumption low.

> 💡 Bob only calls MCP tools when your request genuinely requires them — they don't activate silently in the background.

### 11a. MCP in Practice: The Memory Knowledge Graph

One of the most powerful built-in MCP integrations is the **memory server** — a structured, queryable knowledge graph that persists information across conversations.

> 💡 *Familiar concept:* The memory knowledge graph is a **graph database** (think Neo4j or Amazon Neptune) connected to Bob via MCP. Entities are nodes, observations are properties, and relations are typed edges. Querying it mid-conversation via `@memory:knowledge-graph` is like running a Cypher or Gremlin query against a live graph — except in plain English.

**How it works:**
- Bob can store **entities** (people, products, features, concepts) with observations attached to each
- **Relations** between entities are stored as typed edges (e.g. `has_feature`, `depends_on`, `precedes_in_workflow`)
- The entire graph is accessible at any time via the `@memory:knowledge-graph` resource mention in chat

**What it is NOT:**
- It is not `AGENTS.md` — `AGENTS.md` is project-scoped text loaded at conversation start
- The memory graph is a **structured, cross-project, cross-session store** you can query, update, and reason over mid-conversation

**Comparing the two persistence mechanisms:**

| | `AGENTS.md` | Memory Knowledge Graph |
|--|-------------|----------------------|
| **Scope** | One project | Cross-project, global |
| **Format** | Free-form markdown | Structured entities + typed relations |
| **When loaded** | Automatically at conversation start | On demand via `@memory:knowledge-graph` |
| **Updated by** | `/init` or manual edit | Bob via MCP tools mid-conversation |
| **Best for** | Project conventions, stack, file structure | Team knowledge, domain concepts, architecture decisions |

**Example — reading the graph in chat:**
```
@memory:knowledge-graph
What features of IBM Bob are relevant to context management?
```

**Example — Bob populating the graph:**
```
Store the following in the knowledge graph:
- Entity: PaymentService (type: Component)
  - Observation: Handles all Stripe webhook processing
  - Observation: Depends on OrderService for order state
- Relation: PaymentService depends_on OrderService
```

> 💡 *For Project Owners:* Use the memory graph to capture architecture decisions, team conventions, and domain knowledge that should survive across multiple projects and conversations — not just the current one.

---

## 12. DEMO: Build a Pure Java CLI IBAN Checker

> **Goal:** Show IBM Bob's core capabilities end-to-end through building a pure, dependency-free Java CLI tool — starting with simple validation (starts with "DE", length 22) and iteratively improving it via Literate Coding to support formatted IBANs with spaces.

### Demo Setup (do before presenting)

- [ ] IBM Bob open, workspace empty or fresh folder
- [ ] Auto-approve: **Read ON**, **Edit & Execute OFF** (manual — audience sees every step)
- [ ] Java 21+ and Maven available in terminal
- [ ] Terminal open and ready for CLI execution
- [ ] Font size bumped up for screen visibility

---

### Demo Part 1 — Plan Mode: Design before coding

**Feature:** Plan mode + agentic chat
**⏱ Expected Bob processing time:** < 15 sec

**Prompt:**
```
I want to build a pure Java CLI application (single class with main method, no external frameworks, no Spring Boot) that validates German IBAN numbers passed as a command-line argument.

Requirements:
- Input: In main(String[] args), join all arguments with String.join(" ", args) if args is non-empty, so spaced inputs are handled cleanly
- Initial validation rules in validate(String iban):
  1. Must start with "DE"
  2. Total length must be exactly 22 characters without spaces (e.g. "DE89370400440532013000")
  3. Formatted IBANs containing whitespace between numbers/characters must NOT be allowed in this initial version (must return false / FAIL)
- Output:
  - Prints "PASS" to stdout if valid
  - Prints "FAIL" to stdout if invalid or missing arguments (never System.exit(1) or stderr usage message)
- Makefile with targets: build, test, run (e.g. `make run IBAN="DE..."`)
- Single class: IbanChecker.java in package com.example.iban

Create a plan for this project as a checklist in a plan.md file.
```

**Narrate:**
- Bob is in **Plan mode** — it designs, but cannot run code
- Walk through the generated `plan.md` with the audience
- *"Bob plans before touching code — just like we should"*

---

### Demo Part 2 — Agent Mode: Generate the project

**Feature:** Agent mode, file generation, todo tracking, approval flow
**⏱ Expected Bob processing time:** ~15 sec

**Switch to Agent mode, then run:**
```
Implement the plan in plan.md. Do not run anything yet.
```

**Narrate:**
- Point out the **live todo list** — Bob tracks its own progress step by step
- Each file write appears for **manual approval** — click through them one by one
- *"I see and approve every file before it's written"*

---

### Demo Part 3 — Execute: Compile & Run via CLI

**Feature:** Execute approval, terminal integration
**⏱ Expected Bob processing time:** < 5 sec

**Prompt:**
```
Run the test cases using make run.
```

**Narrate:**
- Bob proposes an **Execute** action — show the exact command before approving
- Show live execution in terminal:
  - `make run IBAN="DE89370400440532013000"` → `PASS`
  - `make run IBAN="FR1420041010050500013M02606"` → `FAIL`
  - `make run IBAN="DE123"` → `FAIL`
  - `make run` (missing argument) → `FAIL`
  - Show that `make run IBAN="DE89 3704 0044 0532 0130 00"` (with spaces) outputs `FAIL` initially — setting up the next demo step!

---

### Demo Part 4 — Literate Coding: Support IBANs with Spaces

**Feature:** Literate coding
**⏱ Expected Bob processing time:** < 10 sec

**Steps:**
1. Open `IbanChecker.java` in the editor
2. Press `Cmd+I` / `Ctrl+I` (or click the magic wand icon)
3. Type above the validate method:
```
// Strip all whitespace/spaces from the input IBAN before checking prefix and length. Also update or add unit tests in IbanCheckerTest if needed to verify formatted IBANs with spaces.
```
4. Press `Cmd+Enter` → show the inline diff → accept it
5. Run `make run IBAN="DE89 3704 0044 0532 0130 00"` → verify it now prints `PASS`!

**Narrate:**
- *"No chat. My instruction directly in the file."*
- *"Blue text = my instruction. Bob turns it into a code diff."*

---

### Demo Part 5 — Context Mentions & Ask Mode: Explain the code

**Feature:** Ask mode + context mentions
**⏱ Expected Bob processing time:** < 10 sec

**Switch to Ask mode, then run:**
```
@/src/main/java/com/example/iban/IbanChecker.java
Explain how the validate method handles null and whitespace sanitisation, and why the method design is pure and thread-safe.
```

**Narrate:**
- *"Ask mode — read-only. Bob explains, never edits."*
- Show the `@` mention autocomplete in the chat input
- *"Perfect for onboarding: ask Bob to explain any file in the codebase"*

---

### Demo Part 6 — /init: Persistent project knowledge

**Feature:** /init and AGENTS.md
**⏱ Expected Bob processing time:** ~15 sec

**Switch to Agent mode, then run:**
```
/init
```

**Narrate:**
- Bob scans the project and generates `AGENTS.md`
- Open the file — walk through what Bob captured: stack, structure, conventions
- *"From now on, every new conversation loads this automatically. Bob never forgets the project."*
- Show the mode-specific files in `.bob/` folder

---

### Demo Part 7 — Rollback: Undo safely

**Feature:** Rollback
**⏱ Expected Bob processing time:** Instant

**Steps:**
1. Ask Bob to make a clearly visible wrong change:
```
Change the valid output message from PASS to OK_VALIDATED
```
2. Approve the file edit — show the change in the editor
3. Hover over the *previous* prompt in chat → click **Rollback**
4. Show the file instantly restored to `PASS`

**Narrate:**
- *"No Git commands. Roll back to any point in the conversation."*
- *"This is your safety net for experimentation."*

---

### Optional — Demo Part 8: Custom slash command

**Feature:** Custom slash commands
**⏱ Expected Bob processing time:** < 10 sec

**Steps:**
1. Show (or create live) `.bob/commands/check-code.md`:
```markdown
Review the current open file for:
- Edge case handling (nulls, empty strings, Unicode whitespace)
- Performance and memory allocations
- Clean single-responsibility method design
Provide specific, actionable feedback with code examples.
```
2. Type `/check-code` in chat — show the autocomplete — run it against `IbanChecker.java`

**Narrate:**
- *"One command. Standardised. Checked into version control. Available to every team member."*

---

## 12b. Ready-to-Use Prompt Playbook

> These prompts are designed as **one-shot inputs** — paste them into Bob exactly as written for a clean, complete result with no follow-up clarification needed. Run each in **Agent mode** unless noted otherwise.

---

### Prompt 1 — Scaffold the Pure Java CLI IBAN Checker

**Mode:** Agent
**What it produces:** A pure Java project with a single `IbanChecker.java` CLI class and JUnit 5 tests.

```
Create a pure Java CLI application for German IBAN validation using Java 21 with Maven.

Requirements:
- Pure standard Java (no Spring Boot, no external framework dependencies)
- Main class: src/main/java/com/example/iban/IbanChecker.java
- Method: public static boolean validate(String iban)
  - Return true if it starts with "DE" and has exact length of 22 characters without spaces (e.g. "DE89370400440532013000")
  - Whitespace between characters/digits is NOT allowed in this initial version (return false)
  - Return false for any null, empty, wrong prefix, or wrong length input
- Method: public static void main(String[] args)
  - If args is empty or null -> System.out.println("FAIL")
  - Otherwise, call validate(String.join(" ", args)) and print "PASS" (if true) or "FAIL" (if false)
- pom.xml: include only junit-jupiter for unit testing

Do not add extra dependencies.
Do not run the application yet.
```

**Expected output:** `IbanChecker.java`, `pom.xml` in standard Maven directory structure.

---

### Prompt 2 — Generate Comprehensive JUnit 5 Tests

**Mode:** Agent
**What it produces:** Complete unit test suite covering happy paths and all edge cases.

```
Write comprehensive JUnit 5 unit tests for IbanChecker in src/test/java/com/example/iban/IbanCheckerTest.java.

Requirements:
- Test valid German IBANs (e.g. "DE89370400440532013000", "DE89 3704 0044 0532 0130 00", lowercase "de89...") -> assert true
- Test invalid country prefixes (e.g. "FR1420041010050500013M02606", "GB82WEST12345698765432") -> assert false
- Test invalid lengths (too short like "DE12345", too long like "DE89370400440532013000999") -> assert false
- Test null and blank strings -> assert false
- Test main(String[] args) output streams for "PASS" and "FAIL"

After creating the file, explain how to run the test suite via Maven.
```

**Expected output:** `IbanCheckerTest.java` and terminal test run commands (`mvn test`).

---

### Prompt 3 — Package as Standalone Executable JAR

**Mode:** Agent
**What it produces:** Maven shade plugin configuration for direct CLI execution.

```
Configure Maven in pom.xml to build a standalone runnable JAR for the IBAN Checker CLI.

Requirements:
- Use maven-shade-plugin or maven-jar-plugin
- Set mainClass to com.example.iban.IbanChecker
- Ensure the user can run: java -jar target/iban-checker.jar "DE89370400440532013000"

Explain the exact terminal commands to package and execute the JAR.
```

**Expected output:** Updated `pom.xml` with shade plugin and copy-paste run commands.

---

### How to execute the CLI — quick reference

| Action | Command |
|--------|---------|
| Run all tests | `make test` (or `mvn test`) |
| Compile project | `make build` |
| Test valid IBAN | `make run IBAN="DE89370400440532013000"` (prints `PASS`) |
| Test invalid IBAN | `make run IBAN="FR1420041010050500013M02606"` (prints `FAIL`) |
| Test with spaces | `make run IBAN="DE89 3704 0044 0532 0130 00"` |
| Test missing argument | `make run` (prints `FAIL`) |

> 💡 **Prompt engineering note:** The prompts above follow the pure Java CLI paradigm:
> - **Zero bloat** — no Spring Boot or Web server overhead
> - **Instant execution** — starts in milliseconds
> - **Explicit contracts** — simple "PASS" / "FAIL" stdout contract

---

### Prompt 4 — Ask Mode: Explain an Unknown Codebase

**Mode:** Ask
**What it produces:** A full architectural explanation of a real-world Java banking project — with analogies, Mermaid diagrams, and a comparison table — without writing a single line of code.

> 💡 This prompt is intentionally short. Bob already knows *how* to explain a codebase because of the rules in `bob-config/rules/ask-mode.md` — analogies, Mermaid diagrams, tables, onboarding tips. The prompt only needs to say *what* to explain. Open that file during the demo to show the audience exactly where the structured output comes from.

**Setup:** Point Bob at the repo with a context mention:

**The prompt:**
```
@https://github.com/ohbus/retail-banking

Explain this banking application to a new backend developer joining the team.
Do not suggest any code changes.
```

**What to expect from Bob:**
- Plain-English summary of the system
- Restaurant + hospital analogies mapping to the architecture
- User journey flowchart (registration → login → accounts → transfer → history)
- Architecture layers diagram (controller → service → repository → database)
- Functional areas table with key classes
- Three concrete onboarding tips specific to this codebase
- Runs entirely in **Ask mode** — zero file changes, zero execute actions

> 🎯 **Demo tip:** Before running the prompt, open `bob-config/rules/ask-mode.md` and show the "Explaining an Unknown Codebase" section. Then run the prompt. The audience sees Bob produce exactly what the rule specifies — making the connection between rules and output concrete and immediate.

---

## 13. Tips for Getting the Most from Bob

| Tip | Why it matters |
|-----|---------------|
| **Start with Plan mode** for new features | Prevents wasted implementation on wrong architecture |
| **Be specific in prompts** | "Create an `IbanChecker` class with `validate(String)` returning boolean" >> "make an IBAN validator" |
| **Use `@mentions`** instead of copy-pasting | Keeps context precise and token-efficient |
| **Run `/init` after major project changes** | Stale `AGENTS.md` = stale suggestions |
| **Keep Edit & Execute on manual approval** | Full oversight, especially on sensitive projects |
| **Use rollback freely** | Treat it as Ctrl+Z for entire Bob sessions — experiment without fear |
| **Start new conversations for new tasks** | Fresh context = sharper reasoning; avoid accumulating unrelated noise |
| **Use Ask mode for code reviews** | Zero risk of accidental changes; great for onboarding and auditing |

---

## 14. Q&A

**Suggested questions to seed the discussion:**

- *"How does Bob compare to GitHub Copilot / Cursor?"*  
  → Bob is agentic and multi-file. It plans, implements, and executes across your whole codebase — not just line autocomplete.

- *"Is my code sent to IBM?"*  
  → Telemetry does **not** collect your code, prompts, or sensitive data. Check your organisation's enterprise config for model routing details.

- *"Can I use Bob with Jira, Monday, or internal APIs?"*  
  → Yes — via MCP. Any tool that can expose an MCP server can be wired into Bob.

- *"What if Bob makes a mistake?"*  
  → Rollback restores your files to any previous state instantly. Manual approval on Edit and Execute means Bob cannot touch your codebase without your explicit sign-off.

- *"How do I roll out Bob conventions across my team?"*  
  → Commit `AGENTS.md`, `.bob/commands/`, and `.bob/custom_modes.yaml` to your repo. Every team member gets the same context, commands, and modes automatically.

---

*Generated for IBM Bob 2.x — verify demo steps match your environment before presenting.*
