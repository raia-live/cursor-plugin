---
name: amfs-workflow
description: Use AMFS from Cursor — uvx MCP, AMFS_HTTP_URL and AMFS_API_KEY like the dashboard MCP card. Use for briefing → search → write → outcome workflows.
---

# AMFS workflow (Cursor)

## Connection (same as dashboard **MCP Connection**)

1. **Agents** page on [amfs.sense-lab.ai](https://amfs.sense-lab.ai/agents) — **Server URL** (e.g. `https://amfs-login.sense-lab.ai`) → `AMFS_HTTP_URL`. **API key** from **Settings → API Keys** → set as `AMFS_API_KEY` in your environment (the plugin uses `${env:AMFS_API_KEY}` in `mcp.json`).
2. **[uv](https://docs.astral.sh/uv/)** on `PATH` — Cursor runs `uvx amfs-mcp-server`.
3. **MCP** — Enable **amfs** under **Settings → Features → Model Context Protocol**.

The hosted API base URL has **no `/mcp` suffix** in this mode; the local MCP process speaks stdio to Cursor and HTTP to Sense Lab using `AMFS_HTTP_URL`.

## Entity paths

Use hierarchical paths: `{repo}/{service-or-module}` (e.g. `myapp/auth`, `acme/api`).

## Session flow

1. **`amfs_briefing(entity_path="...")`**
2. **`amfs_search`** / **`amfs_recall`**
3. **`amfs_write`**
4. **`amfs_record_context`**
5. **`amfs_commit_outcome`**
6. **`amfs_explain`** / **`amfs_history`**

## Docs

- [AMFS documentation](https://raia-live.github.io/amfs/)
- [MCP + Sense Lab (Cursor)](https://raia-live.github.io/amfs/guides/mcp/#amfs-pro-saas-and-cursor)
- [Hosted AMFS (SaaS)](https://raia-live.github.io/amfs/guides/saas/)
