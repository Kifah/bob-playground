# bob-config

Shared IBM Bob global configuration — skills, modes, and rules that apply across all projects and all machines on the team.

Clone this repo once, run the install script, and every Bob session on your machine inherits the team's shared configuration automatically.

---

## What's inside

```
bob-config/
├── skills/
│   └── youtube-transcript/     ← extract & summarise any YouTube video
│       ├── SKILL.md
│       └── scripts/
│           └── extract.sh
├── settings/
│   └── custom_modes.yaml       ← (placeholder) shared custom modes
├── rules/
│   └── (placeholder)           ← shared global rules
└── README.md
```

| Directory | Bob global path | Purpose |
|---|---|---|
| `skills/` | `~/.bob/skills/` | On-demand instruction sets Bob loads when task matches |
| `settings/custom_modes.yaml` | `~/.bob/settings/custom_modes.yaml` | Custom modes available in every project |
| `rules/` | `~/.bob/rules/` | Standing instructions injected into every conversation |

---

## Installation

### Option A — Symlink (recommended)

Symlinks keep `~/.bob/` pointing at this repo. Any `git pull` here is instantly reflected in Bob — no re-install needed.

```sh
# 1. Clone the repo somewhere stable (e.g. ~/dev/bob-config)
git clone <repo-url> ~/dev/bob-config
cd ~/dev/bob-config

# 2. Run the install script
sh install.sh
```

### Option B — Manual symlinks

If you prefer to pick and choose which parts to install:

```sh
BOB_CONFIG="$(pwd)"   # run from the bob-config directory

# Skills — symlink each skill individually
ln -s "$BOB_CONFIG/skills/youtube-transcript" ~/.bob/skills/youtube-transcript

# Global rules — symlink the whole directory (or individual files)
# ln -s "$BOB_CONFIG/rules" ~/.bob/rules

# Custom modes
# ln -s "$BOB_CONFIG/settings/custom_modes.yaml" ~/.bob/settings/custom_modes.yaml
```

---

## install.sh

The install script lives at the root of this repo:

```sh
sh install.sh
```

It creates `~/.bob/skills/`, `~/.bob/rules/`, and `~/.bob/settings/` if they don't exist, then symlinks each item from `bob-config/` into the corresponding `~/.bob/` path. Existing symlinks are skipped (not overwritten) — remove them manually first if you want to re-link.

---

## Keeping up to date

Since everything is symlinked, a simple pull is all you need:

```sh
cd ~/dev/bob-config
git pull
```

Bob picks up the changes immediately — no restart needed for rules and skills (new conversations will see them; the current session will not).

---

## Adding a new skill

1. Create a folder under `skills/`:
   ```
   skills/
   └── my-skill/
       ├── SKILL.md
       └── scripts/        ← optional
   ```

2. `SKILL.md` format:
   ```markdown
   ---
   name: my-skill
   description: One or two sentences — Bob uses this to decide when to activate the skill.
   ---

   Full instructions here. This is only loaded into context when the skill activates.
   ```

3. Add a symlink on your machine (the install script handles this for new team members):
   ```sh
   ln -s "$(pwd)/skills/my-skill" ~/.bob/skills/my-skill
   ```

4. Commit and push — other team members run `git pull` and re-run `install.sh`.

---

## Available skills

### `youtube-transcript`

Extracts and cleans the transcript from any YouTube video so Bob can summarise, explain, or cross-reference it.

**Activates when:** you provide a YouTube URL and ask Bob to read, summarise, or analyse the video.

**Requires:** `yt-dlp` installed on your machine.
```sh
brew install yt-dlp        # macOS
pip install yt-dlp         # any platform
```

**Example prompts:**
```
Summarise this video for me: https://www.youtube.com/watch?v=vEm9vRFeDis
```
```
Based on this video https://www.youtube.com/watch?v=qdAozfL1mXw, what gaps do we have in our documentation?
```

Bob will download the subtitles, clean them, read the transcript, and answer — then delete the `.vtt` file automatically.
