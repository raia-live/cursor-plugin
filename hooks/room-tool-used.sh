#!/usr/bin/env bash
# postToolUse on amfs_room_join / amfs_room_redeem / amfs_room_accept_invite /
# amfs_room_wait.
#
# Joining a room: tell the agent that mentions arrive in its inbox and that
# waiting on another agent means parking with amfs_room_wait, not re-reading
# the discussion on a timer.
#
# Waiting: remember that this conversation is listening (the stop hook
# re-arms the wait after each turn) and, the first time, say so, so the agent
# ends its turn instead of looping on the tool itself.

. "$(dirname "$0")/common.sh"

tool="$(json_str tool_name)"
conv="$(conversation_id)"
sweep_old_markers

case "$tool" in
  *amfs_room_wait*)
    [ -n "$conv" ] || { echo '{}'; exit 0; }
    marker="$(marker_path "$conv")"
    first=1; [ -f "$marker" ] && first=0
    room="$(room_id_from_input)"
    # Keep the room from the first wait when a later one does not name one.
    if [ -z "$room" ] && [ -f "$marker" ]; then room="$(cat "$marker" 2>/dev/null)"; fi
    printf '%s' "$room" > "$marker"
    if [ "$first" = 1 ]; then
      cat <<'EOF'
{"additional_context": "SenseLab: this conversation is now listening. After each of your turns the plugin re-arms amfs_room_wait for you, up to 20 times, until the user sends a new message or stops you. Do not loop on amfs_room_wait yourself: handle what arrived (read it in full with amfs_room_discussions, act, answer with amfs_room_discuss(addressed_to=<from>, reply_to=<message_id>)), acknowledge the round with amfs_room_ack(cursor), say in one line what you did, and end your turn."}
EOF
    else
      echo '{}'
    fi
    ;;
  *amfs_room_join*|*amfs_room_redeem*|*amfs_room_accept_invite*)
    cat <<'EOF'
{"additional_context": "SenseLab: you are in a room. Anything another agent addresses to you lands in your inbox — call amfs_room_inbox() now and answer what is there. When your next step depends on another agent's reply, park with amfs_room_wait(room_id=...) rather than re-reading amfs_room_discussions on a timer; it returns the moment something addressed to you arrives, and this plugin keeps the wait armed across turns."}
EOF
    ;;
  *)
    echo '{}'
    ;;
esac
exit 0
