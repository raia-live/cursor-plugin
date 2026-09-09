# Syncing plugin content

This repository ships the SenseLab Cursor plugin: an always-applied rule, an
agent guide skill, and the MCP server configuration for the hosted API.

## Source of truth

| Shipped file | Source | Notes |
|--------------|--------|-------|
| `rules/senselab-learning.mdc` | `raia-live/amfs` → `.cursor/rules/` | Always-applied behavioural rule. Keep it tight — it is injected into every request. |
| `skills/senselab-learning/SKILL.md` | `raia-live/amfs` → `packages/agent-guide/cursor/` | The fuller guide, loaded on demand. |
| `mcp.json` | `raia-live/amfs-internal` → `dashboard/src/lib/public-api-url.ts` (`PRODUCTION_MCP_URL`) | The remote Streamable HTTP endpoint. Must be the host the gateway's OAuth discovery documents name as the resource (`mcp.sense-lab.ai`, not `amfs-login`), with no trailing slash — Cursor compares it byte-for-byte against the protected-resource metadata. |
| `assets/logo.png` | Dashboard brand mark | Square, transparent background, 512×512. |

## When the server changes

The rule and skill describe tool behaviour, so a change to the server's tool
surface usually means both need editing.

The plugin talks to the hosted gateway (`raia-live/amfs-internal` →
`packages/mcp-gateway`), so the tool surface users see is whatever the gateway
serves to an OAuth grant's profile — not the `amfs-mcp-server-pro` package, and
not `amfs-internal` main. The gateway registers the six untagged builder tools
plus the `surface:full` set from `tools_memory.py`, `tools_rooms.py` and
`tools_openai.py`; check what is registered before a release with:

```bash
git grep -h -o -E '(name="amfs_[a-z_]+"|def amfs_[a-z_]+)' origin/main -- packages/mcp-gateway/src
```

The stdio Pro server documented in the README's advanced section carries the
intelligence-layer tools (critic, distiller, calibration, training export) that
the gateway does not. If those are added to the gateway, the capability table in
`README.md` stays accurate; if they are not, do not describe them as available
through the plugin.

In particular:

1. If tools are added or removed, re-check the capability table in `README.md`.
   It is written by category on purpose — an exhaustive tool list goes stale
   quickly and previously did.
2. If the metered cost of an operation changes, update the cost table in the
   skill. It currently states reads at 1 op, writes at 2, and outcomes free.
3. If the MCP host changes, update `mcp.json` and the MCP block in `README.md`
   together, and confirm the gateway's `AMFS_PUBLIC_URL` and the
   protected-resource metadata advertise the same origin.
4. Cursor only renders the **Connect** button when the *unauthenticated
   `initialize`* itself gets a `401` with a `WWW-Authenticate` challenge; a
   server that accepts `initialize` and rejects `tools/list` shows an opaque
   error instead. The gateway's `MCPAuthMiddleware` does this today — keep it
   that way.

## When the guide changes

Copy the rule and skill from the source repository, then re-read them as a
whole rather than pasting in isolation: the two overlap deliberately, with the
rule holding the short always-on instructions and the skill the detail.

Two edits made here in 3.0.0 are ahead of the sources and must be carried back
before the next copy, or the copy will reintroduce the problem: the identity
step reads "if `amfs_set_identity` is offered" and the room-document section
reads "where the connection offers these tools". Both exist because the hosted
gateway serves neither yet. If the gateway gains `amfs_set_identity`,
`amfs_whoami`, and the `amfs_room_document_*` set, the conditionals can go.

## Releasing

1. Bump `version` in `.cursor-plugin/plugin.json` following semver. Renaming the
   MCP server or changing which package it runs is breaking.
2. Add an entry to `CHANGELOG.md` describing the user-visible effect, not just
   the file that changed.
3. Validate the manifest against the published schema. `ajv-cli` does not
   fetch remote schemas and needs the `email` format registered, so download
   it first and load `ajv-formats`:

   ```bash
   curl -sSL -o /tmp/plugin.schema.json \
     https://raw.githubusercontent.com/cursor/plugins/main/schemas/plugin.schema.json
   npx --yes -p ajv-cli -p ajv-formats ajv validate -c ajv-formats \
     -s /tmp/plugin.schema.json -d .cursor-plugin/plugin.json
   ```

## Outstanding branding gaps

User-facing surfaces are SenseLab throughout, but three identifiers still carry
the old name and cannot be changed from this repository:

- MCP tool names are prefixed `amfs_`, and agents show them in chat.
- The advanced stdio path uses the environment variables `AMFS_API_KEY` and
  `AMFS_HTTP_URL`, and its API host is `amfs-login.sense-lab.ai`.
- The dashboard is on the `amfs` subdomain; `app.sense-lab.ai` does not
  resolve. The OAuth approval page lives there too, so users see the `amfs`
  host in the browser while connecting.
- The docs site is titled SenseLab but every page sits under an `/amfs/` path
  prefix, so `docs.sense-lab.ai` redirects to `/amfs/introduction`. Links here
  deliberately use the bare domain to keep the prefix out of link text.
- The PyPI package is `amfs-mcp-server-pro`.

Renaming any of these needs server-side aliases (and, for the tool names, a
deprecation window where both are accepted).
