# Changelog

All notable changes to this plugin are documented here.

## 3.0.0

Breaking: the plugin now connects to SenseLab's hosted MCP endpoint over
Streamable HTTP with browser OAuth, instead of running `amfs-mcp-server-pro`
locally with a pasted API key. Cursor treats the transport change as a new
connection: after upgrading, the `senselab` server shows **Needs
authentication**, and one click on **Connect** finishes the setup.

Why: the 2.x install never reliably asked for the key. Cursor only prompts for
plugin variables in some install paths, never on upgrade from a release that
had none, and never for a local install — and when no value is set it launches
the server with the literal `${AMFS_API_KEY}` placeholder. The server then
fails every call with "Invalid or missing API key" and nothing in the UI points
at the fix, because a stdio server has no way to ask Cursor for credentials. A
remote server can: it answers with a `401` challenge that Cursor turns into the
Connect button.

- Point `mcp.json` at `https://mcp.sense-lab.ai/mcp` (`type: http`). No
  `command`, no `env`, no `uvx` requirement.
- Remove the `variables` block and the `AMFS_API_KEY` prompt. There is nothing
  for the user to paste.
- Rewrite the README install steps around Connect → sign in → Approve, replace
  the key- and `uvx`-centred troubleshooting with the OAuth states Cursor
  actually shows, and move the local stdio server to an advanced section for
  self-hosted deployments, configured in the user's own `~/.cursor/mcp.json`.
- The rule and skill now say "if the tool is offered" for `amfs_set_identity`
  and the room document tools, and point agents at the connection's tool list
  as authoritative. The hosted gateway derives agent identity from the MCP
  client and does not yet serve `amfs_set_identity`, `amfs_whoami`, or
  `amfs_room_document_*`; an instruction to call a tool that is not there was
  making agents report the server as broken. These edits need upstreaming to
  the rule and skill sources in `raia-live/amfs` (see `SYNC.md`).
- The capability table describes the hosted surface. The intelligence-layer
  tools (critique, distil, calibrate, training export) remain on the local Pro
  server documented in the advanced section.

## 2.1.0

Positioning: SenseLab is continual learning, not memory. Memory is how it
works, not what it is for, and the plugin described the mechanism while
sense-lab.ai and the Claude connector listing describe the product.

- Reword the manifest description, README and component guides to lead on
  knowledge that carries forward and is reinforced by outcomes. `memory` stays
  in `keywords` because people search for it.
- Rename `rules/senselab-memory.mdc` to `rules/senselab-learning.mdc` and the
  `senselab-memory` skill to `senselab-learning`. Cursor keys skills by name,
  so the old one disappears and the new one appears on upgrade.

## 2.0.0

Breaking: the plugin and its MCP server are now named `senselab`. Cursor treats
this as a new server, so agents reconnect on upgrade and any local config
referencing the old `amfs` server name should be removed.

- Point the MCP server at `amfs-mcp-server-pro`, which serves the full tool
  surface. The previous release ran the open-source package against the hosted
  API, which exposed roughly a third of the tools and no rooms, room documents,
  negotiations, or consolidation.
- Collect the API key through a `variables` block, so Cursor prompts for it on
  install. Previously the key was read from `${env:AMFS_API_KEY}`, which
  required setting a shell variable before launching Cursor and failed silently
  on a marketplace install.
- Declare `mcpServers`, `rules`, and `skills` in the manifest, and add
  `category`, `tags`, `publisher`, and `minClientVersions` for the marketplace
  listing.
- Rewrite the description as a plain summary of what the plugin does, replacing
  the MCP configuration notes that previously filled the listing.
- Rebrand to SenseLab throughout, and replace the placeholder logo with the
  SenseLab mark.
- Update the rule and skill to cover semantic recall, action recording, rooms,
  room documents, room discovery and access requests, and negotiation conduct,
  and to state that memory holds personal preferences as well as engineering
  context.
- Require agents to ask before requesting room access, or approving, declining,
  or granting it, since those change who can read a room's memory.
- Replace the fixed tool list in the README with a capability table, since the
  running server is the source of truth and the old list had gone stale.

## 1.3.0

- Trimmed the bundled agent guide.

## 1.0.0

- First release: memory rule, agent guide skill, and MCP server configuration.
