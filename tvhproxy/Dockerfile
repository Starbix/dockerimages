FROM alpine

COPY rootfs /

ENV UID=991 GID=991

RUN apk update \
    && apk add python \
    py-flask \
    py-requests \
    py-gevent \
    git s6 su-exec patch \
    && mkdir -p /opt \
    && cd /opt \
    && git clone https://github.com/jkaberg/tvhProxy \
    && cd tvhProxy \
    && patch tvhProxy.py /tmp/tvh.patch \
    && apk del git patch\
    && chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
    && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 5004/tcp
EXPOSE 5004/udp

CMD ["/usr/local/bin/run.sh"]
