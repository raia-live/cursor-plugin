# Syncing content from AMFS

This repository ships **Cursor IDE plugin** assets (rules, skill, MCP wiring) for [AMFS](https://github.com/raia-live/amfs).

## Source of truth

| Shipped file | Upstream (AMFS repo) |
|--------------|----------------------|
| `rules/amfs-memory.mdc` | `raia-live/amfs` → `.cursor/rules/amfs-memory.mdc` |
| MCP behavior | `raia-live/amfs` → `packages/mcp-server` and [MCP guide](https://raia-live.github.io/amfs/guides/mcp/) |

## When you change upstream

1. Copy or merge the updated rule from AMFS into `rules/amfs-memory.mdc` (preserve valid YAML frontmatter: `description`, `alwaysApply` or `globs`).
2. If tool names or workflows change, update `skills/amfs-workflow/SKILL.md` and `README.md`.
3. Bump `version` in `.cursor-plugin/plugin.json` following semver.
4. Tag or release this repo if you use GitHub releases for marketplace updates.

## Plugin version vs `amfs-mcp-server`

The MCP server is published separately on PyPI as **`amfs-mcp-server`**. This plugin invokes it via `uvx amfs-mcp-server`. You do not need to bump the plugin version for every PyPI release unless README or user-facing instructions change.
