FROM alpine:3.10
LABEL maintainer="Starbix"

ENV UID=991 GID=991

COPY rootfs /

RUN apk add -U \
				npm \
				git \
				su-exec \
				s6 \
		&& mkdir -p /opt \
		&& cd /opt \
		&& git clone https://github.com/UnicornTranscoder/UnicornLoadBalancer \
		&& cd UnicornLoadBalancer \
		&& npm install \
		&& chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
		&& apk del git \
		&& rm -rf /tmp/* /var/cache/apk/*

EXPOSE 3001

CMD ["run.sh"]
