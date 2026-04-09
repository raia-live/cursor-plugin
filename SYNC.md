# Syncing content from AMFS

This repository ships the **AMFS** Cursor plugin for Sense Lab’s hosted service (rules, skill, **hosted** MCP via `url` + `Authorization` header).

## Source of truth

| Shipped file | Notes |
|--------------|--------|
| `rules/amfs-memory.mdc` | Often mirrored from `raia-live/amfs` → `.cursor/rules/amfs-memory.mdc` (OSS agent guidance). |
| `mcp.json` | Hosted MCP: `url` defaults to `https://api.raia.live/mcp`. Update if product uses a different production base URL. |

## When you change upstream or product URLs

1. Merge rule updates from AMFS OSS if desired (preserve valid YAML frontmatter).
2. If the production MCP base URL changes, update `mcp.json` and **README.md** in lockstep.
3. Bump `version` in `.cursor-plugin/plugin.json` (semver).

## OSS vs this plugin

Self-hosted / local MCP (`uvx amfs-mcp-server`, Postgres, etc.) is documented in the [AMFS OSS MCP guide](https://raia-live.github.io/amfs/guides/mcp/). This plugin targets **hosted** AMFS (Sense Lab).
