#!/usr/bin/env bash
# Shared by the room hooks. Sourced, not run.
#
# Hooks exchange JSON over stdin/stdout. These scripts need a handful of
# string fields from machine-written JSON and must run on a bare macOS or
# Linux without jq, python or node on PATH, so the fields are pulled with
# sed. Every script fails open: a parse miss prints an empty object.
#
# State is one small file per conversation under a temp directory. It says
# "this conversation is listening on a room", nothing more; losing it only
# means the wait is not re-armed.

set -u

HOOK_INPUT="$(cat)"
STATE_DIR="${TMPDIR:-/tmp}/senselab-cursor-hooks"
mkdir -p "$STATE_DIR" 2>/dev/null || STATE_DIR="/tmp"

# First string value for a key. Stops at the next quote, so it is right for
# identifiers (all these scripts read) and wrong for free text; keys inside
# a JSON-stringified value (tool_output) do not match because their quotes
# are escaped. BSD sed has no alternation, hence grep -o first.
json_str() {
  printf '%s' "$HOOK_INPUT" \
    | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -n 1 \
    | sed 's/^"[^"]*"[[:space:]]*:[[:space:]]*"//; s/"$//'
}

# The JSON emitted by Cursor for an MCP call carries the arguments as an
# object under tool_input, so a room id is simply the first "room_id" key.
room_id_from_input() {
  local id
  id="$(json_str room_id)"
  case "$id" in
    *[!0-9a-fA-F-]*|"") printf '' ;;
    *) printf '%s' "$id" ;;
  esac
}

marker_path() { printf '%s/%s.wait' "$STATE_DIR" "$1"; }

# Conversations do not end with a hook that reliably fires, so markers older
# than a day are swept on every run.
sweep_old_markers() {
  find "$STATE_DIR" -name '*.wait' -mmin +1440 -delete 2>/dev/null || true
}

conversation_id() {
  local id
  id="$(json_str conversation_id)"
  case "$id" in
    *[!A-Za-z0-9_-]*|"") printf '' ;;
    *) printf '%s' "$id" ;;
  esac
}
