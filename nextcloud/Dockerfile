ARG VERSION="stable-"
FROM nextcloud:${VERSION}fpm-alpine

ENV NEXTCLOUD_UPDATE=1
ENV TRUSTED_PROXIES="127.0.0.1 ::1"

ENV PHP_UPLOAD_LIMIT=8G
ENV PHP_MEMORY_LIMIT=1G

RUN set -ex; \
    \
    apk add --no-cache \
        ffmpeg \
        imagemagick \
        procps \
        supervisor \
        nginx \
        su-exec \
    ;

COPY supervisord.conf /
COPY entrypoint_ext.sh /
COPY nginx*.conf /etc/nginx/
COPY occ /usr/local/bin

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;

## PHP modifications
RUN echo "pm.max_children = 16" >> /usr/local/etc/php-fpm.d/www.conf \
    && sed -i '/^listen = 9000/c\listen = /var/run/php-fpm.sock' /usr/local/etc/php-fpm.d/zz-docker.conf \
    && printf "listen.owner = nginx\nlisten.group = nginx\n" >> /usr/local/etc/php-fpm.d/zz-docker.conf

RUN sed -i '/exec "$@"/d' /entrypoint.sh \
   && echo "$(cat /entrypoint_ext.sh)" >> /entrypoint.sh

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
