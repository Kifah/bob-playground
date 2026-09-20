# Web Search and Web Extraction — Use Exa

An Exa MCP server is connected and provides two tools:

- `web_search_exa` — search the web by query
- `web_fetch_exa` — fetch and read the full content of one or more URLs as clean Markdown

## Rules

**Always prefer Exa over any built-in fallback:**
- When you need to search the internet for any topic, call `web_search_exa` first.
- When you need to read the content of a specific URL, call `web_fetch_exa` first.
- `@URL` context mentions are a fallback only — use them only if `web_fetch_exa` is unavailable.
- In Agent mode: proactively call `web_fetch_exa` whenever a URL is provided in the conversation,
  rather than waiting for the user to type it as an `@URL` mention.

**Never fabricate web results:**
- Do not invent search results, page contents, or summaries.
- If the tool call fails or returns no results, say so explicitly and ask the user how to proceed.

**Never claim you cannot search the web:**
- As long as the `exa` MCP server is connected, you have web search capability.
- Do not say "I don't have access to the internet" or "I cannot browse the web".
