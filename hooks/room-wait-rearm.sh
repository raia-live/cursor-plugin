#!/usr/bin/env bash
# stop: if this conversation is listening on a room and the turn ended on its
# own (not aborted, not errored), submit the next wait as a follow-up.
#
# The hosted MCP endpoint bounds one amfs_room_wait at 240 seconds; the
# follow-up is what turns that into a session that keeps listening. The
# hooks.json loop_limit (20) caps it at about eighty minutes, a new user
# message resets it (room-wait-reset.sh), and the stop button ends it.

. "$(dirname "$0")/common.sh"

conv="$(conversation_id)"
[ -n "$conv" ] || { echo '{}'; exit 0; }
marker="$(marker_path "$conv")"
[ -f "$marker" ] || { echo '{}'; exit 0; }

status="$(json_str status)"
if [ "$status" != "completed" ]; then
  rm -f "$marker"
  echo '{}'
  exit 0
fi

room="$(cat "$marker" 2>/dev/null)"
if [ -n "$room" ]; then
  call="amfs_room_wait(room_id=\\\"$room\\\")"
else
  call="amfs_room_wait()"
fi

printf '{"followup_message": "[senselab] Still listening: call %s once more. If something addressed to you arrives, read it in full with amfs_room_discussions, act on it, answer with amfs_room_discuss(addressed_to=<from>, reply_to=<message_id>), and acknowledge with amfs_room_ack(cursor). If the wait times out with nothing, say so in one line and end your turn."}\n' "$call"
exit 0
