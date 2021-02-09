ARG VERSION="stable-"
FROM nextcloud:${VERSION}fpm-alpine

ENV NEXTCLOUD_UPDATE=1
ENV TRUSTED_PROXIES="127.0.0.1 ::1"

RUN set -ex; \
    \
    apk add --no-cache \
        ffmpeg \
        imagemagick \
        procps \
        supervisor \
        nginx \
    ;

COPY supervisord.conf /
COPY nginx.conf /etc/nginx/

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
