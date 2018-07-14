FROM alpine:3.8
LABEL maintainer="Starbix"

ENV UID=991 GID=991

COPY rootfs /

RUN apk add -U \
				nodejs-npm \
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

CMD ["run.sh"]
