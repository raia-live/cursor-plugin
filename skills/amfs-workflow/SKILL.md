---
name: amfs-workflow
description: Use AMFS from Cursor with hosted MCP — API key, briefing and memory workflows. Use when connecting AMFS in Cursor, choosing entity paths, or following briefing → search → write → outcome flows.
---

# AMFS workflow (Cursor)

## Connection

1. **Dashboard** ([sense-lab.ai](https://www.sense-lab.ai)) — API key and (if needed) the exact **MCP URL** for your tenant.
2. **Environment** — Set `AMFS_API_KEY` so Cursor can resolve `${env:AMFS_API_KEY}` in the plugin’s `mcp.json`.
3. **MCP** — Enable the **amfs** server under **Settings → Features → Model Context Protocol**. Default endpoint: `https://amfs-login.sense-lab.ai/mcp` unless your dashboard specifies otherwise.

## Entity paths

Use hierarchical paths: `{repo}/{service-or-module}` (e.g. `myapp/auth`, `acme/api`).

## Session flow

1. **`amfs_briefing(entity_path="...")`** — start here for compiled context from the Memory Cortex.
2. **`amfs_search`** / **`amfs_recall`** — drill into specifics.
3. **`amfs_write`** — record decisions, patterns, risks, and task summaries (optional `memory_type`: `fact`, `belief`, `experience`).
4. **`amfs_record_context`** — after important external tool/API use, so traces stay complete.
5. **`amfs_commit_outcome`** — after deploys or incidents to update confidence.
6. **`amfs_explain`** / **`amfs_history`** — inspect traces and how an entry evolved.

## Docs

- [AMFS documentation](https://raia-live.github.io/amfs/)
- [MCP setup (incl. hosted Cursor)](https://raia-live.github.io/amfs/guides/mcp/)
