# AMFS — Cursor plugin

Official Cursor plugin for **[AMFS](https://raia-live.github.io/amfs/)** (Agent Memory File System): shared, versioned memory for coding agents with MCP tools for briefing, search, writes, outcomes, and decision traces.

**Repository:** [github.com/raia-live/cursor-plugin](https://github.com/raia-live/cursor-plugin)  
**Submit / install via Cursor:** [Cursor Marketplace](https://cursor.com/marketplace) (after listing) · [Publish a plugin](https://cursor.com/marketplace/publish)

## What you get

- **Rules** — When to call `amfs_briefing`, `amfs_write`, `amfs_search`, outcomes, and entity naming (`{repo}/{module}`).
- **Skill** — `amfs-workflow` for setup and session flow (`/amfs-workflow` in chat when applicable).
- **MCP server** — `amfs` via [`uvx amfs-mcp-server`](https://pypi.org/project/amfs-mcp-server/) (stdio). No absolute paths to a local clone.

### MCP tools (PyPI `amfs-mcp-server`)

`amfs_read`, `amfs_write`, `amfs_search`, `amfs_list`, `amfs_stats`, `amfs_commit_outcome`, `amfs_history`, `amfs_record_context`, `amfs_recall`, `amfs_my_entries`, `amfs_read_from`, `amfs_cross_agent_reads`, `amfs_explain`, `amfs_briefing`, `amfs_timeline`

## Prerequisites

- **Python 3.11+** on your machine (used by `uvx` to run the MCP server).
- **[uv](https://docs.astral.sh/uv/)** installed and on your `PATH` (recommended). Cursor will run `uvx amfs-mcp-server` as configured in `mcp.json`.

### If you do not use `uv`

Install the server into an environment that is on your `PATH`, then override MCP in your project or user config to use:

```json
{
  "mcpServers": {
    "amfs": {
      "command": "amfs-mcp-server",
      "args": [],
      "env": {}
    }
  }
}
```

Install: `pip install amfs-mcp-server`

## Project setup (memory store)

AMFS stores data per **project** (after `amfs init`):

```bash
pip install amfs-cli
cd /path/to/your/repo
amfs init
```

This creates `amfs.yaml` and `.amfs/` (add `.amfs/` to `.gitignore` if you use local filesystem storage and do not want data committed). For team backends (Postgres, etc.), see the [AMFS MCP guide](https://raia-live.github.io/amfs/guides/mcp/).

## Cursor

1. Install this plugin from the marketplace (or test locally; see below).
2. **Settings → Features → Model Context Protocol** — ensure the **amfs** server is enabled.
3. Use the bundled rules (e.g. **Always** or **Agent Decides**) under **Settings → Rules**.

## Optional environment variables

Same as the AMFS MCP server (see [server CLI](https://github.com/raia-live/amfs/blob/main/packages/mcp-server/src/amfs_mcp/server.py) and docs), for example:

| Variable | Purpose |
|----------|---------|
| `AMFS_POSTGRES_DSN` | Postgres backend for shared team memory |
| `AMFS_AGENT_ID` | Override auto-detected agent id |
| `AMFS_TRANSPORT` | e.g. `http` for remote MCP (advanced) |

Set them in the MCP server `env` block if you customize the server entry in Cursor.

## Local testing (before publish)

```bash
mkdir -p ~/.cursor/plugins/local
ln -sf /absolute/path/to/cursor-plugin ~/.cursor/plugins/local/amfs
```

Restart Cursor or **Developer: Reload Window**. Confirm the rule and MCP server load.

## Syncing from AMFS

See [SYNC.md](./SYNC.md). Bump `.cursor-plugin/plugin.json` `version` when you ship material rule or doc changes.

## License

Apache-2.0 — see [LICENSE](./LICENSE).
