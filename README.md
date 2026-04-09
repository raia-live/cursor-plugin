# AMFS — Cursor plugin

Official Cursor plugin for **[AMFS](https://raia-live.github.io/amfs/)** on **Sense Lab** — same wiring as the **Agents → MCP Connection** card in the dashboard ([amfs.sense-lab.ai/agents](https://amfs.sense-lab.ai/agents)).

**Homepage:** [sense-lab.ai](https://www.sense-lab.ai) · **Docs:** [raia-live.github.io/amfs](https://raia-live.github.io/amfs/)  
**Repository:** [github.com/raia-live/cursor-plugin](https://github.com/raia-live/cursor-plugin)

## What you get

- **Rules** — When to call `amfs_briefing`, `amfs_write`, `amfs_search`, outcomes, and entity naming (`{repo}/{module}`).
- **Skill** — `amfs-workflow` for session flow (`/amfs-workflow` in chat when applicable).
- **MCP** — Cursor runs `uvx amfs-mcp-server` (stdio). The process uses **`AMFS_HTTP_URL`** (Sense Lab **Server URL**, e.g. `https://amfs-login.sense-lab.ai`) and **`AMFS_API_KEY`** to talk to the hosted API. There is **no `/mcp` on that URL** for this setup — `/mcp` is only for *remote* Streamable HTTP when the MCP server itself listens as an HTTP service.

### MCP tools

`amfs_read`, `amfs_write`, `amfs_search`, `amfs_list`, `amfs_stats`, `amfs_commit_outcome`, `amfs_history`, `amfs_record_context`, `amfs_recall`, `amfs_my_entries`, `amfs_read_from`, `amfs_cross_agent_reads`, `amfs_explain`, `amfs_briefing`, `amfs_timeline` — plus tools your server version may add. Check **Available Tools** in Cursor after connecting.

## Setup (matches dashboard)

1. **API key** — Create one under **Settings → API Keys** on the AMFS dashboard.
2. **`AMFS_API_KEY` in your environment** — Set it where Cursor resolves [config interpolation](https://cursor.com/docs/mcp.md#config-interpolation) (e.g. shell profile, or macOS **launchd** / Windows user environment). The plugin’s `mcp.json` uses `"AMFS_API_KEY": "${env:AMFS_API_KEY}"` so the key is never committed.
3. **[uv](https://docs.astral.sh/uv/)** — Must be on your `PATH` so `uvx amfs-mcp-server` can run (Cursor spawns this process).
4. **Install the plugin** — Marketplace (when listed) or local symlink (below).
5. **Settings → Features → Model Context Protocol** — Enable the **amfs** server.
6. **Settings → Rules** — Enable the bundled rules as you prefer.

If your dashboard shows a different **Server URL**, change `AMFS_HTTP_URL` in `mcp.json` (or override in Cursor MCP settings). You can pin a version with `"args": ["amfs-mcp-server@x.y.z"]` if you want.

## Local testing (developers)

```bash
mkdir -p ~/.cursor/plugins/local
export AMFS_API_KEY="your-key-from-settings-api-keys"
ln -sf /absolute/path/to/cursor-plugin ~/.cursor/plugins/local/amfs
```

Restart Cursor or **Developer: Reload Window**. Check **Output → MCP Logs** if tools do not appear.

## Syncing from AMFS OSS

See [SYNC.md](./SYNC.md). Bump `.cursor-plugin/plugin.json` `version` when you ship material changes.

## License

Apache-2.0 — see [LICENSE](./LICENSE).
