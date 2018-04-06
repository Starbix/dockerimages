FROM alpine
LABEL maintainer="Starbix"

ENV UID=991 GID=991

ENV DEBUG="false"
ENV PORT=2389
ENV HOST=0.0.0.0

RUN apk add -U s6 su-exec nodejs-npm git \
		&& mkdir -p /opt \
		&& cd /opt \
		&& git clone https://github.com/hjone72/LDAP-for-Plex \
		&& cd LDAP-for-Plex \
		&& npm install \
		&& apk del git \
		&& rm -rf /tmp/* /var/cache/apk/*

COPY rootfs /

RUN chmod a+x /usr/local/bin/* /etc/s6.d/*/*

EXPOSE 2389

CMD ["run.sh"]
