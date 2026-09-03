# Changelog

All notable changes to this plugin are documented here.

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
