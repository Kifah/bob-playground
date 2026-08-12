#!/bin/sh
# Usage: extract.sh <path-to-vtt-file>
# Strips VTT timestamps, position tags, and HTML tags,
# then removes duplicate consecutive lines to produce a clean transcript.

VTT_FILE="$1"

if [ -z "$VTT_FILE" ] || [ ! -f "$VTT_FILE" ]; then
  echo "Usage: extract.sh <path-to-vtt-file>" >&2
  exit 1
fi

grep -v "^WEBVTT" "$VTT_FILE" \
  | grep -v "^Kind:" \
  | grep -v "^Language:" \
  | grep -v "^$" \
  | grep -v " --> " \
  | grep -v "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]" \
  | sed 's/<[^>]*>//g' \
  | awk '!seen[$0]++' \
  | sed '/^[[:space:]]*$/d'
