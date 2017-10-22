FROM frolvlad/alpine-mono

ENV UID=991 GID=991
ENV USEDEBUG="NO"

COPY rootfs /

RUN apk upgrade --no-cache \
    && apk add --no-cache python sqlite tzdata curl libcurl su-exec s6 \
    && apk add libmediainfo --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache \
    && mkdir -p /opt/lidarr \
    && export LIDARR_VERSION="$(curl 'https://ci.appveyor.com/api/projects/lidarr/lidarr' | sed -n 's/.*"version":"\(.*\)",/\1/p' | cut -d\" -f1)" \
    # && export LIDARR_BRANCH="$(curl 'https://ci.appveyor.com/api/projects/lidarr/lidarr' | sed -n 's/.*"repositoryBranch":"\(.*\)",/\1/p' | cut -d\" -f1)" \
    && export LIDARR_BRANCH="react" \
    && curl -o /tmp/lidarr.tar.gz -L https://ci.appveyor.com/api/projects/Lidarr/lidarr/artifacts/_artifacts/Lidarr.$LIDARR_BRANCH.$LIDARR_VERSION.linux.tar.gz \
    && tar xvzf /tmp/lidarr.tar.gz  -C /opt/lidarr --strip-components=1 \
    && rm -rf /tmp/* \
    && chmod u+x /usr/local/bin/* /etc/s6.d/*/*


EXPOSE 8686
VOLUME /config

CMD ["run.sh"]
