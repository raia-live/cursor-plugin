---
name: amfs-workflow
description: Use AMFS (Agent Memory File System) for persistent, shared agent memory. Use when onboarding a project to AMFS, deciding entity paths, or following briefing → search → write → outcome workflows with MCP.
---

# AMFS workflow

## Before you start

1. **Project / tenant**: **AMFS Pro (SaaS)** — use your organization’s hosted setup from the AMFS dashboard; no self-hosted Postgres or MCP `env` configuration. For local OSS-style storage only, install the CLI and run `amfs init` in the repo (creates `amfs.yaml` and `.amfs/`).

   ```bash
   pip install amfs-cli
   amfs init
   ```

   Use `uv` if you prefer: `uv tool install amfs-cli` then `amfs init`.

2. **Cursor MCP**: This plugin ships an `amfs` MCP server (via `uvx amfs-mcp-server`). Ensure the server is enabled under **Settings → Features → Model Context Protocol**.

## Entity paths

Use hierarchical paths: `{repo}/{service-or-module}` (e.g. `myapp/auth`, `amfs/core-engine`).

## Session flow

1. **`amfs_briefing(entity_path="...")`** — start here for compiled context from the Memory Cortex.
2. **`amfs_search`** / **`amfs_recall`** — drill into specifics.
3. **`amfs_write`** — record decisions, patterns, risks, and task summaries (optional `memory_type`: `fact`, `belief`, `experience`).
4. **`amfs_record_context`** — after important external tool/API use, so traces stay complete.
5. **`amfs_commit_outcome`** — after deploys or incidents to update confidence.
6. **`amfs_explain`** / **`amfs_history`** — inspect traces and how an entry evolved.

## MCP tools (reference)

`amfs_read`, `amfs_write`, `amfs_search`, `amfs_list`, `amfs_stats`, `amfs_commit_outcome`, `amfs_history`, `amfs_record_context`, `amfs_recall`, `amfs_my_entries`, `amfs_read_from`, `amfs_cross_agent_reads`, `amfs_explain`, `amfs_briefing`, `amfs_timeline`

## Docs

- [AMFS MCP setup](https://raia-live.github.io/amfs/guides/mcp/)
- [AMFS documentation](https://raia-live.github.io/amfs/)
