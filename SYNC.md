# Syncing content from AMFS

This repository ships the **AMFS Pro / SaaS** Cursor plugin (rules, skill, **hosted** MCP via `url` + `Authorization` header).

## Source of truth

| Shipped file | Notes |
|--------------|--------|
| `rules/amfs-memory.mdc` | Often mirrored from `raia-live/amfs` → `.cursor/rules/amfs-memory.mdc` (OSS agent guidance). |
| `mcp.json` | **Pro:** `url` points at Raia’s hosted MCP (`https://api.raia.live/mcp` by default). Update if product uses a different production base URL. |

## When you change upstream or product URLs

1. Merge rule updates from AMFS OSS if desired (preserve valid YAML frontmatter).
2. If the production MCP base URL changes, update `mcp.json` and **README.md** in lockstep.
3. Bump `version` in `.cursor-plugin/plugin.json` (semver).

## OSS vs this plugin

Self-hosted / local MCP (`uvx amfs-mcp-server`, Postgres, etc.) is documented in the [AMFS OSS MCP guide](https://raia-live.github.io/amfs/guides/mcp/). This plugin targets **AMFS Pro** customers only.
