ARG VERSION=""
FROM docker.io/nextcloud:${VERSION}fpm-alpine

ENV NEXTCLOUD_UPDATE=1 \
    TRUSTED_PROXIES="127.0.0.1 ::1" \
    PHP_UPLOAD_LIMIT=8G \
    PHP_MEMORY_LIMIT=1G \
    ENABLE_PUSH=0

RUN set -ex; \
    apk add --no-cache \
        ffmpeg \
        imagemagick \
        procps \
        supervisor \
        nginx \
        su-exec \
    ; \
    # Remap www-data to match Unraid's nobody:users (99:100)
    sed -i 's/^\([^:]*\):x:100:/\1:x:1100:/' /etc/group; \
    sed -i 's/^\([^:]*\):x:99:\([0-9]*\):/\1:x:1099:\2:/' /etc/passwd; \
    sed -i 's/^www-data:x:[0-9]*:[0-9]*:/www-data:x:99:100:/' /etc/passwd; \
    sed -i 's/^www-data:x:[0-9]*:/www-data:x:100:/' /etc/group; \
    find / -xdev \( -user 82 -o -group 82 \) -exec chown -h 99:100 {} + 2>/dev/null || true; \
    # Serve JS as text/javascript and add .mjs
    sed -i -e 's|application/javascript|text/javascript|' -e 's|js;|mjs js;|' /etc/nginx/mime.types; \
    mkdir -p /var/log/supervisord /var/run/supervisord

COPY rootfs/ /

CMD ["/usr/local/bin/start.sh"]
