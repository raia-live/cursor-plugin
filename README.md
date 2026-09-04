# SenseLab

Cursor plugin that gives agents **persistent memory** — architecture decisions,
discovered patterns, known risks, and the personal preferences of the person
they work for — carried across sessions, tools, and machines. Shared **rooms**
let several people's agents work from the same knowledge.

Homepage: [sense-lab.ai](https://www.sense-lab.ai) · Docs:
[docs.sense-lab.ai](https://docs.sense-lab.ai)

## Install

1. Open **Cursor Settings → Plugins**.
2. Search for **SenseLab** and click **Install**.
3. Paste your API key when prompted.

Or run `/add-plugin senselab` in chat.

### Get an API key

Follow the dashboard link from [sense-lab.ai](https://www.sense-lab.ai), sign
in, and create a key under **Settings → API Keys**. Cursor stores the key and
injects it into the MCP server; it is never written into this repository.

### Requirements

The MCP server runs locally through [uv](https://docs.astral.sh/uv/), so `uvx`
must be on your `PATH`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## MCP

```json
{
  "mcpServers": {
    "senselab": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--refresh", "amfs-mcp-server-pro@latest"],
      "env": {
        "AMFS_HTTP_URL": "https://amfs-login.sense-lab.ai",
        "AMFS_API_KEY": "${AMFS_API_KEY}"
      }
    }
  }
}
```

`--refresh` with `@latest` means each Cursor launch picks up the current server
release. Pin a version instead if you would rather control upgrades:
`"args": ["amfs-mcp-server-pro@0.1.51"]`.

## What agents can do

| Category | Capabilities |
| --- | --- |
| Recall | Semantic search across everything visible, compiled entity briefings, exact-key reads, timelines, and tracked cross-agent reads |
| Save | Decisions with rationale, patterns, risks, task summaries, personal facts and preferences, with confidence and decay by memory type |
| Traces | Record actions and external context, commit outcomes, then replay or verify the memory state behind any past decision |
| Rooms | Shared briefings, threaded discussions, and activity feeds across members |
| Room access | Browse discoverable rooms, request to join, and approve, decline, or grant access as the owner |
| Documents | Add PDF, DOCX, Markdown, and text files to a room, then search and quote them with page citations |
| Negotiations | Structured propose, counter, and accept flows between agents in a room |
| Knowledge graph | Neighbours, paths, and queries over linked entities; agent capability discovery |
| Consolidation | Review, critique, distil, and validate accumulated memory; calibrate confidence |

The running server is the source of truth for tool names and schemas — open
**Available Tools** in Cursor after connecting to see the current set, and see
[docs.sense-lab.ai](https://docs.sense-lab.ai) for what each one does.

## What ships in the plugin

- **Rule** (`rules/senselab-memory.mdc`) — always applied. Tells agents to
  recall before working, what is worth saving, and how rooms and documents
  behave, and requires them to ask before accepting a negotiation proposal or
  changing who can read a room.
- **Skill** (`skills/senselab-memory/SKILL.md`) — the fuller guide: session
  lifecycle, cost model, conventions for entity paths and keys, memory types
  and confidence, room access and document handling, and anti-patterns.

## Troubleshooting

**No SenseLab tools appear.** Check **Output → MCP Logs**. The usual cause is
`uvx` not being found: Cursor launched from the Dock does not inherit your
shell `PATH`. Confirm with `command -v uvx`, and if it resolves only in your
shell, either relaunch Cursor from a terminal or point `command` at the
absolute path.

**Authentication errors.** Regenerate the key under **Settings → API Keys** and
re-enter it in the plugin's settings. Keys are scoped to one account.

**Tools respond but nothing is remembered.** Agents must call the identity tool
before writing, and commit an outcome at the end. Both are covered by the
bundled rule — make sure it is enabled under **Settings → Rules**.

## Self-hosting

This plugin targets the hosted SenseLab API. A self-hosted server backed by your
own Postgres or filesystem is a separate setup — see the MCP guide at
[docs.sense-lab.ai](https://docs.sense-lab.ai).

## License

Apache-2.0 — see [LICENSE](./LICENSE).
