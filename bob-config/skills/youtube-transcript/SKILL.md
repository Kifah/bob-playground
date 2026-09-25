---
name: youtube-transcript
description: Use this skill when the user provides a YouTube URL and wants to extract, read, or analyse the video transcript or subtitles.
---

Extract and clean the transcript from a YouTube video, then make it available for analysis, summarisation, or Q&A.

## Workflow

1. Run the following command to download the auto-generated English subtitles (no video download):

```sh
yt-dlp --write-auto-sub --skip-download --sub-lang "en.*,en" "<YOUTUBE_URL>"
```

Replace `<YOUTUBE_URL>` with the URL provided by the user.

2. Run the cleaning script to strip VTT timestamps and HTML tags and deduplicate repeated lines:

```sh
sh scripts/extract.sh "<PATH_TO_VTT_FILE>"
```

The script will print the clean transcript to stdout.

3. Read the clean transcript output and use it to answer the user's question in English — summarise, explain, extract key points, or cross-reference with other files in the project as requested.

## Rules

- **English only**: Always extract English subtitles (`--sub-lang "en.*,en"` or `--sub-lang en,en-US,en-GB`). Never download non-English subtitles unless explicitly instructed by the user. If the video is in another language with auto-generated translated English captions, use English.
- Always clean up the downloaded `.vtt` file after reading it — do not leave it in the working directory.
- If `yt-dlp` is not installed, tell the user to install it: `brew install yt-dlp` (macOS) or `pip install yt-dlp`.
- Never download the actual video file.
- The transcript is the raw input — always read it fully before forming a response.
