#!/bin/sh
# install.sh — symlink bob-config into ~/.bob/
# Run from the bob-config directory: sh install.sh

set -e

BOB_CONFIG="$(cd "$(dirname "$0")" && pwd)"
BOB_HOME="$HOME/.bob"

echo "Installing bob-config from: $BOB_CONFIG"
echo "Target: $BOB_HOME"
echo ""

# Create ~/.bob directories if they don't exist
mkdir -p "$BOB_HOME/skills"
mkdir -p "$BOB_HOME/rules"
mkdir -p "$BOB_HOME/settings"
mkdir -p "$BOB_HOME/commands"

# ── Skills ────────────────────────────────────────────────────────────────────
for skill_dir in "$BOB_CONFIG/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$BOB_HOME/skills/$skill_name"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "  skip  skills/$skill_name (already exists — remove manually to re-link)"
  else
    ln -s "$skill_dir" "$target"
    echo "  link  skills/$skill_name → $target"
  fi
done

# ── Rules ─────────────────────────────────────────────────────────────────────
for rule_file in "$BOB_CONFIG/rules"/*.md; do
  [ -e "$rule_file" ] || continue   # skip if no .md files yet
  rule_name="$(basename "$rule_file")"
  target="$BOB_HOME/rules/$rule_name"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "  skip  rules/$rule_name (already exists)"
  else
    ln -s "$rule_file" "$target"
    echo "  link  rules/$rule_name → $target"
  fi
done

# ── Custom modes ───────────────────────────────────────────────────────────────
modes_src="$BOB_CONFIG/settings/custom_modes.yaml"
modes_target="$BOB_HOME/settings/custom_modes.yaml"
if [ -f "$modes_src" ]; then
  if [ -e "$modes_target" ] || [ -L "$modes_target" ]; then
    echo "  skip  settings/custom_modes.yaml (already exists)"
  else
    ln -s "$modes_src" "$modes_target"
    echo "  link  settings/custom_modes.yaml → $modes_target"
  fi
fi

# ── MCP config ────────────────────────────────────────────────────────────────
mcp_src="$BOB_CONFIG/mcp/mcp.json"
mcp_target="$BOB_HOME/mcp.json"
if [ -f "$mcp_src" ]; then
  if [ -e "$mcp_target" ] || [ -L "$mcp_target" ]; then
    echo "  skip  mcp.json (already exists — remove manually to re-link)"
  else
    ln -s "$mcp_src" "$mcp_target"
    echo "  link  mcp.json → $mcp_target"
  fi
fi

# ── Commands ──────────────────────────────────────────────────────────────────
for cmd_file in "$BOB_CONFIG/commands"/*.md; do
  [ -e "$cmd_file" ] || continue   # skip if no .md files yet
  cmd_name="$(basename "$cmd_file")"
  target="$BOB_HOME/commands/$cmd_name"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "  skip  commands/$cmd_name (already exists)"
  else
    ln -s "$cmd_file" "$target"
    echo "  link  commands/$cmd_name → $target"
  fi
done

echo ""
echo "Done. Start a new Bob conversation to pick up the changes."
