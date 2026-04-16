# Syncing content from AMFS

This repository ships the **AMFS** Cursor plugin for Sense Lab (rules, skill, MCP via **`uvx` + `AMFS_HTTP_URL` + `AMFS_API_KEY`**, matching the **Agents → MCP Connection** JSON).

## Source of truth

| Shipped file | Source | Notes |
|--------------|--------|-------|
| `rules/amfs-memory.mdc` | `raia-live/amfs` → `.cursor/rules/amfs-memory.mdc` | Always-applied behavioral rules for AMFS agents. |
| `skills/amfs-memory/SKILL.md` | `raia-live/amfs` → `packages/agent-guide/cursor/SKILL.md` | Full agent memory guide — cost model, session lifecycle, what to save/skip, anti-patterns. |
| `mcp.json` | Dashboard MCP Connection card | Must stay aligned with the live dashboard snippet (`uvx`, `amfs-mcp-server`, `https://amfs-login.sense-lab.ai`, `${env:AMFS_API_KEY}`). |

## When the dashboard changes

1. Update `mcp.json` and **README.md** if **Server URL** or recommended `args` change.
2. Bump `version` in `.cursor-plugin/plugin.json` (semver).

## When the agent guide changes

1. Copy `packages/agent-guide/cursor/SKILL.md` from `raia-live/amfs` to `skills/amfs-memory/SKILL.md`.
2. Bump `version` in `.cursor-plugin/plugin.json` (semver).

## OSS vs this plugin

Self-hosted Postgres/filesystem MCP is documented in the [AMFS MCP guide](https://raia-live.github.io/amfs/guides/mcp/). This plugin targets Sense Lab's hosted API via `AMFS_HTTP_URL`.
