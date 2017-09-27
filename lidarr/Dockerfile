FROM frolvlad/alpine-mono

ENV UID=991 GID=991
ENV USEDEBUG="NO"

ARG LIDARRVER=0.2.0.44

COPY rootfs /

RUN apk upgrade --no-cache \
    && apk add --no-cache python sqlite tzdata curl libcurl su-exec s6 \
    && mkdir -p /opt/lidarr \
    && curl -o /tmp/lidarr.tar.gz -L https://ci.appveyor.com/api/projects/Lidarr/lidarr/artifacts/_artifacts/Lidarr.react.$LIDARRVER.linux.tar.gz \
    && tar xvzf /tmp/lidarr.tar.gz  -C /opt/lidarr --strip-components=1 \
    && rm -rf /tmp/* \
    && chmod u+x /usr/local/bin/* /etc/s6.d/*/*


EXPOSE 8686
VOLUME /config

CMD ["run.sh"]
