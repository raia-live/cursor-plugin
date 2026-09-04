# Syncing plugin content

This repository ships the SenseLab Cursor plugin: an always-applied rule, an
agent guide skill, and the MCP server configuration for the hosted API.

## Source of truth

| Shipped file | Source | Notes |
|--------------|--------|-------|
| `rules/senselab-learning.mdc` | `raia-live/amfs` → `.cursor/rules/` | Always-applied behavioural rule. Keep it tight — it is injected into every request. |
| `skills/senselab-learning/SKILL.md` | `raia-live/amfs` → `packages/agent-guide/cursor/` | The fuller guide, loaded on demand. |
| `mcp.json` | Dashboard **MCP Connection** card | Must stay aligned with the live snippet: `uvx`, `amfs-mcp-server-pro`, API host, and key variable. |
| `assets/logo.png` | Dashboard brand mark | Square, transparent background, 512×512. |

## When the server changes

The rule and skill describe tool behaviour, so a change to the server's tool
surface usually means both need editing.

Content here is written against `raia-live/amfs-internal` **main**, which can
lead the published package. At the time of writing main defines 91 tools while
`amfs-mcp-server-pro@latest` serves 82; the nine not yet published are the room
discovery and access-request set (`amfs_room_discover`,
`amfs_room_set_discoverable`, `amfs_room_details`, `amfs_room_members`,
`amfs_room_request_access`, `amfs_room_access_requests`,
`amfs_room_approve_access`, `amfs_room_decline_access`,
`amfs_room_grant_access`). Because `mcp.json` resolves `@latest` on every
launch, users pick them up as soon as pro republishes. Verify the gap before a
release with:

```bash
git grep -h -o -E 'def (amfs_[a-z_]+)' origin/main -- packages/mcp-server-pro/src
```

In particular:

1. If tools are added or removed, re-check the capability table in `README.md`.
   It is written by category on purpose — an exhaustive tool list goes stale
   quickly and previously did.
2. If the metered cost of an operation changes, update the cost table in the
   skill. It currently states reads at 1 op, writes at 2, and outcomes free.
3. If the hosted API host or the recommended `args` change, update `mcp.json`
   and the MCP block in `README.md` together.

## When the guide changes

Copy the rule and skill from the source repository, then re-read them as a
whole rather than pasting in isolation: the two overlap deliberately, with the
rule holding the short always-on instructions and the skill the detail.

## Releasing

1. Bump `version` in `.cursor-plugin/plugin.json` following semver. Renaming the
   MCP server or changing which package it runs is breaking.
2. Add an entry to `CHANGELOG.md` describing the user-visible effect, not just
   the file that changed.
3. Validate the manifest against the published schemas:

   ```bash
   npx --yes ajv-cli validate \
     -s https://raw.githubusercontent.com/cursor/plugins/main/schemas/plugin.schema.json \
     -d .cursor-plugin/plugin.json
   ```

## Outstanding branding gaps

User-facing surfaces are SenseLab throughout, but three identifiers still carry
the old name and cannot be changed from this repository:

- MCP tool names are prefixed `amfs_`, and agents show them in chat.
- The environment variables are `AMFS_API_KEY` and `AMFS_HTTP_URL`.
- The hosted API host is `amfs-login.sense-lab.ai` and the dashboard is on the
  `amfs` subdomain; `app.sense-lab.ai` does not resolve.
- The docs site is titled SenseLab but every page sits under an `/amfs/` path
  prefix, so `docs.sense-lab.ai` redirects to `/amfs/introduction`. Links here
  deliberately use the bare domain to keep the prefix out of link text.
- The PyPI package is `amfs-mcp-server-pro`.

Renaming any of these needs server-side aliases (and, for the tool names, a
deprecation window where both are accepted).
