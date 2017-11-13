FROM alpine

ENV UID=991 GID=991

COPY rootfs /

RUN apk add -U git nodejs-current-npm s6 \
    && mkdir -p /opt \
    && cd /opt \
    && git clone https://github.com/MediaButler/MediaButler \
    && cd MediaButler \
    && npm install \
    && chmod u+x /usr/local/bin/* /etc/s6.d/*/*

COPY rootfs /

CMD ["run.sh"]
