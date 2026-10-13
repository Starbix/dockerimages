#!/bin/sh
# CMD: the upstream /entrypoint.sh installs/upgrades Nextcloud, then execs this.
set -e

if [ "$ENABLE_PUSH" = 1 ] && occ status | grep -q "installed: true"; then
    # Installs notify_push first if missing; no-op if already enabled.
    occ app:enable notify_push
fi

chown -R www-data:www-data /tmp

exec /usr/bin/supervisord -c /etc/supervisord.conf
