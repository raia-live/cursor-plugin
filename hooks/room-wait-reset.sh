#!/usr/bin/env bash
# beforeSubmitPrompt: a new message from the user ends the listening loop.
#
# The re-arm follow-up is itself submitted as a prompt and may pass through
# here; it is recognised by its prefix and left alone. Anything else is the
# user changing the subject, and the marker goes.

. "$(dirname "$0")/common.sh"

conv="$(conversation_id)"
if [ -n "$conv" ]; then
  if ! printf '%s' "$HOOK_INPUT" | grep -q '"prompt"[[:space:]]*:[[:space:]]*"\[senselab\] Still listening'; then
    rm -f "$(marker_path "$conv")"
  fi
fi
echo '{"continue": true}'
exit 0
