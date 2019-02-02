FROM alpine:edge
LABEL maintainer="Starbix"

ENV UID=991 GID=991
ENV HOST=0.0.0.0
ARG COTURN_VER=4.5.0.8


RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
		&& apk add -U s6 su-exec libevent libevent-dev sqlite-dev hiredis hiredis-dev postgresql postgresql-dev mongo-c-driver mongo-c-driver-dev mysql-dev build-base linux-headers openssl \
		&& mkdir -p /usr/src \
		&& cd /usr/src \
		&& wget http://turnserver.open-sys.org/downloads/v${COTURN_VER}/turnserver-${COTURN_VER}.tar.gz \
		&& tar xf turnserver-${COTURN_VER}.tar.gz \
		&& cd turnserver-${COTURN_VER} \
		&& ./configure \
		&& make && make install \
		&& apk del libevent-dev hiredis-dev postgresql-dev mongo-c-driver-dev build-base linux-headers \
		&& rm -rf /tmp/* /usr/src /var/cache/apk/*

COPY rootfs /

RUN chmod a+x /usr/local/bin/* /etc/s6.d/*/*

EXPOSE 3478

CMD ["run.sh"]
