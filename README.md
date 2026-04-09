# AMFS — Cursor plugin

Official Cursor plugin for **[AMFS](https://raia-live.github.io/amfs/)** — hosted agent memory with MCP over **Streamable HTTP** to the Sense Lab API. No local MCP process, Python runtime, or self-hosted database configuration.

**Homepage:** [sense-lab.ai](https://www.sense-lab.ai) · **Docs:** [raia-live.github.io/amfs](https://raia-live.github.io/amfs/)  
**Repository:** [github.com/raia-live/cursor-plugin](https://github.com/raia-live/cursor-plugin)

## What you get

- **Rules** — When to call `amfs_briefing`, `amfs_write`, `amfs_search`, outcomes, and entity naming (`{repo}/{module}`).
- **Skill** — `amfs-workflow` for session flow (`/amfs-workflow` in chat when applicable).
- **MCP (hosted)** — Connects Cursor at `https://amfs-login.sense-lab.ai/mcp` (Streamable HTTP; path matches AMFS `AMFS_PATH`, default `/mcp`). Use the **MCP URL** from your dashboard if it differs.

### MCP tools (hosted server)

`amfs_read`, `amfs_write`, `amfs_search`, `amfs_list`, `amfs_stats`, `amfs_commit_outcome`, `amfs_history`, `amfs_record_context`, `amfs_recall`, `amfs_my_entries`, `amfs_read_from`, `amfs_cross_agent_reads`, `amfs_explain`, `amfs_briefing`, `amfs_timeline` — plus additional tools your tenant’s server version may expose (e.g. `amfs_set_identity`, `amfs_retrieve`, graph/timeline helpers). Check **Available Tools** in Cursor after connecting.

## Setup

1. **Account** — Create a project/tenant and issue an **API key** from your Sense Lab / AMFS dashboard ([sense-lab.ai](https://www.sense-lab.ai)).
2. **API key in your environment** — Set `AMFS_API_KEY` where Cursor can see it (shell profile, or macOS **launchd** / Windows user env). The plugin uses [Cursor interpolation](https://cursor.com/docs/mcp.md#config-interpolation): `Bearer ${env:AMFS_API_KEY}` in `mcp.json`.
3. **MCP URL** — Default in this plugin is `https://amfs-login.sense-lab.ai/mcp`. If the **MCP Connection Card** in your dashboard shows a different URL, use that in **Cursor → MCP** or in a fork/local `mcp.json`.
4. **Install the plugin** — Cursor Marketplace (when listed) or local test symlink (below).
5. **Settings → Features → Model Context Protocol** — Enable the **amfs** server.
6. **Settings → Rules** — Use the bundled rules (**Always** or **Agent Decides**) as you prefer.

### OAuth (if your tenant uses it)

Some deployments use OAuth instead of a static API key. Follow the dashboard instructions and [Cursor’s static OAuth MCP config](https://cursor.com/docs/mcp.md#static-oauth-for-remote-servers); you may replace the `headers` block in `mcp.json` with an `auth` object as documented for your environment.

## Local testing (developers)

```bash
mkdir -p ~/.cursor/plugins/local
export AMFS_API_KEY="your-key-from-dashboard"
ln -sf /absolute/path/to/cursor-plugin ~/.cursor/plugins/local/amfs
```

Restart Cursor or **Developer: Reload Window**. Confirm MCP connects (Output → MCP Logs).

## Syncing from AMFS OSS

Rule text may be mirrored from the open-source repo; see [SYNC.md](./SYNC.md). Bump `.cursor-plugin/plugin.json` `version` when you ship material changes.

## License

Apache-2.0 — see [LICENSE](./LICENSE).
