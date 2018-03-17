FROM alpine

COPY rootfs /

ENV UID=991 GID=991

RUN apk update \
    && apk add nodejs nodejs-npm s6 su-exec \
    && apk add -t build-dependencies \
    git go libc-dev \
    && mkdir -p /opt && cd /opt \
    && git clone https://git.teknik.io/SMLoadrDev/SMLoadr \
    && cd SMLoadr \
    && npm install \
    && go get github.com/yudai/gotty \
    && mv /root/go/bin/gotty /usr/local/bin \
    && chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/* /root/*

EXPOSE 4200

VOLUME /opt/SMLoadr/DOWNLOADS

CMD ["run.sh"]
