# Syncing content from AMFS

This repository ships the **AMFS** Cursor plugin for Sense Lab (rules, skill, MCP via **`uvx` + `AMFS_HTTP_URL` + `AMFS_API_KEY`**, matching the **Agents → MCP Connection** JSON).

## Source of truth

| Shipped file | Notes |
|--------------|--------|
| `rules/amfs-memory.mdc` | Often mirrored from `raia-live/amfs` → `.cursor/rules/amfs-memory.mdc`. |
| `mcp.json` | Must stay aligned with the live dashboard snippet (`uvx`, `amfs-mcp-server`, `https://amfs-login.sense-lab.ai`, `${env:AMFS_API_KEY}`). |

## When the dashboard changes

1. Update `mcp.json` and **README.md** if **Server URL** or recommended `args` change.
2. Bump `version` in `.cursor-plugin/plugin.json` (semver).

## OSS vs this plugin

Self-hosted Postgres/filesystem MCP is documented in the [AMFS MCP guide](https://raia-live.github.io/amfs/guides/mcp/). This plugin targets Sense Lab’s hosted API via `AMFS_HTTP_URL`.
