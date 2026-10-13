#!/bin/sh
# Restart notify_push when an app update replaces its binary, so the new
# version runs right away. supervisord brings the daemon back up.
BIN=/var/www/html/custom_apps/notify_push/bin/x86_64/notify_push

fingerprint() { stat -c '%i:%s:%Y' "$BIN" 2>/dev/null; }

cur=$(fingerprint)
while sleep 30; do
    new=$(fingerprint)
    [ -n "$new" ] && [ "$new" != "$cur" ] || continue
    # Let the updater finish copying.
    sleep 5
    echo "notify_push binary replaced, restarting"
    pkill -x notify_push
    cur=$(fingerprint)
done
