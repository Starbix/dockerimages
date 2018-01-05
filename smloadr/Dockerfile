FROM alpine

COPY rootfs /

COPY SMLoadrDesktop /opt/SMLoadr

ENV UID=991 GID=991

RUN apk update \
    && apk add nodejs nodejs-npm s6 su-exec \
    && apk add -t build-dependencies \
    git go libc-dev \
    && cd /opt/SMLoadr \
    && npm install \
    && go get github.com/yudai/gotty \
    && mv /root/go/bin/gotty /usr/local/bin \
    && chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/* /root/*

EXPOSE 4200

VOLUME /opt/SMLoadr/DOWNLOADS

CMD ["/usr/local/bin/run.sh"]
