# SenseLab

Cursor plugin that makes learning **continuous** for your agents. What one
agent works out — architecture decisions, discovered patterns, known risks, and
the personal preferences of the person they work for — becomes what the next
one starts from, carried across sessions, tools, and machines and weighted by
how the work actually turned out. Shared **rooms** let several people's agents
learn from the same knowledge.

Homepage: [sense-lab.ai](https://www.sense-lab.ai) · Docs:
[docs.sense-lab.ai](https://docs.sense-lab.ai)

## Install

1. Open **Cursor Settings → Plugins**, search for **SenseLab**, and click
   **Install**. Or run `/add-plugin senselab` in chat.
2. Open **Cursor Settings → MCP**. The `senselab` server shows
   **Needs authentication** — click **Connect**.
3. Your browser opens the SenseLab dashboard. Sign in (or create an account)
   and click **Approve**.

That is the whole setup: no API key to copy, nothing to install, no Python or
`uvx` on your machine. The connection is an OAuth grant scoped to your SenseLab
account. It shows up in the dashboard under **Settings → API Keys** as a key
named `oauth:<client>`; revoke it there to cut the connection off.

If the browser did not open, click the **Needs authentication** text in the
MCP settings row, or type `mcp_auth` in an agent chat and the agent will start
the sign-in for you.

## MCP

The plugin connects to SenseLab's hosted Streamable HTTP endpoint:

```json
{
  "mcpServers": {
    "senselab": {
      "type": "http",
      "url": "https://mcp.sense-lab.ai/mcp"
    }
  }
}
```

The endpoint is an OAuth 2.1 resource server: it answers an unauthenticated
`initialize` with `401` and a `WWW-Authenticate` challenge that points at its
protected-resource metadata, publishes authorization-server metadata, and
supports dynamic client registration and PKCE. Cursor drives the flow from
there, on the desktop and in Cloud Agents alike.

## What agents can do

| Category | Capabilities |
| --- | --- |
| Recall | Semantic search across everything visible, compiled entity briefings, exact-key reads, timelines, and tracked cross-agent reads |
| Save | Decisions with rationale, patterns, risks, task summaries, personal facts and preferences, with confidence and decay by memory type |
| Traces | Record actions and external context, commit outcomes, then replay or verify the memory state behind any past decision |
| Rooms | Shared briefings, threaded discussions, and activity feeds across members |
| Room access | Browse discoverable rooms, request to join, and approve, decline, or grant access as the owner |
| Negotiations | Structured propose and counter flows between agents in a room, with status and cancellation |
| Knowledge graph | Neighbours of an entity, and verification of the memory state behind a decision |
| Versioning | Commit batches, commit log, diffs, and merge bases across memory branches |

The running server is the source of truth for tool names and schemas — open
**Available Tools** in Cursor after connecting to see the current set, and see
[docs.sense-lab.ai](https://docs.sense-lab.ai) for what each one does. Room
documents (upload, search with page citations) and the intelligence layer
(critique, distil, validate, calibrate, training-data export) are served by the
local Pro server described under **Advanced** below, not by the hosted endpoint
yet.

## What ships in the plugin

- **Rule** (`rules/senselab-learning.mdc`) — always applied. Tells agents to
  recall before working, what is worth saving, and how rooms and documents
  behave, and requires them to ask before accepting a negotiation proposal or
  changing who can read a room.
- **Skill** (`skills/senselab-learning/SKILL.md`) — the fuller guide: session
  lifecycle, cost model, conventions for entity paths and keys, memory types
  and confidence, room access and document handling, and anti-patterns.

## Troubleshooting

**The server says "Needs authentication".** That is the expected state before
you connect. Click **Connect** (or the status text itself) and finish the
sign-in in the browser. If nothing opens, type `mcp_auth` in an agent chat.

**Tools return "Unauthorized" or "Account context required".** The grant has
been revoked or has expired. In **Cursor Settings → MCP**, click **Logout** on
the `senselab` row, then **Connect** again.

**The approval page connects the wrong account.** The page shows the signed-in
email before you approve. If it is not the account you want the agents writing
into, deny, sign out of the dashboard, sign in with the right one, and click
**Connect** again.

**Tools respond but nothing is remembered.** Agents must call the identity tool
before writing, and commit an outcome at the end. Both are covered by the
bundled rule — make sure it is enabled under **Settings → Rules**.

**Upgrading from 2.x.** Earlier releases ran a local `uvx` server configured
with an API key. That server is gone from the plugin; the key it used stays
valid for other clients and can be revoked under **Settings → API Keys** if you
no longer need it. Nothing else migrates — the memory is the same account either
way.

## Advanced: local server with an API key

The hosted endpoint is the right choice for almost everyone. Two situations call
for the local server instead: a self-hosted SenseLab (your own Postgres, your
own host) or an environment where the desktop cannot complete a browser OAuth
flow. In those cases add the server to your own `~/.cursor/mcp.json` rather than
through the plugin, and disable the plugin's `senselab` server so you do not
end up with two:

```json
{
  "mcpServers": {
    "senselab-local": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--refresh", "amfs-mcp-server-pro@latest"],
      "env": {
        "AMFS_HTTP_URL": "https://amfs-login.sense-lab.ai",
        "AMFS_API_KEY": "${env:AMFS_API_KEY}"
      }
    }
  }
}
```

Create the key under **Settings → API Keys** in the dashboard. `${env:...}`
reads the variable from the environment Cursor was launched with, so export it
in your shell profile or replace the placeholder with the key itself. The
server needs [uv](https://docs.astral.sh/uv/) on your `PATH`; Cursor launched
from the Dock does not inherit your shell `PATH`, so if `command -v uvx`
resolves only in a terminal, point `command` at the absolute path. For a
self-hosted deployment, set `AMFS_HTTP_URL` to your own API host — see the MCP
guide at [docs.sense-lab.ai](https://docs.sense-lab.ai).

## License

Apache-2.0 — see [LICENSE](./LICENSE).
