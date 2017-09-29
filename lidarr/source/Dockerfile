FROM frolvlad/alpine-mono

ENV UID=991 GID=991
ENV USEDEBUG="NO"

ARG BRANCH=react

COPY rootfs /

RUN BUILD_DEPS=" \
   nodejs-npm \
   git" \
    && apk upgrade --no-cache \
    && apk add --no-cache python sqlite tzdata curl libcurl su-exec s6 ${BUILD_DEPS} \
    && apk add libmediainfo libgdiplus --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache \
    && cd /tmp \
    && git clone -b $BRANCH https://github.com/lidarr/Lidarr \
    && cd Lidarr \
    && git submodule update --init \
    && npm i -g gulp \
    && npm install --no-optional \
    && npm run build -- --production \
    && export MONO_IOMAP=case \
    && mono ./tools/nuget/nuget.exe restore ./src/Lidarr.sln \
    && xbuild ./src/Lidarr.sln /t:Configuration=Release /p:Platform=x86 /t:Build /p:AllowedReferenceRelatedFileExtensions=.pdb \
    && mv _output/Lidarr.Console.exe _output/Lidarr.exe \
    && mkdir -p /opt/lidarr \
    && cp -a "_output/"* "/opt/lidarr" \
    && find "/opt/lidarr" -type d -exec chmod 755 {} \; \
    && find "/opt/lidarr" -type f -exec chmod 644 {} \; \
    && find "/opt/lidarr" -name \*.exe -type f -exec chmod 755 {} \; \
    && rm -rf /tmp/* \
    && apk del ${BUILD_DEPS} \
    && chmod u+x /usr/local/bin/* /etc/s6.d/*/*


EXPOSE 8686
VOLUME /config

CMD ["run.sh"]
