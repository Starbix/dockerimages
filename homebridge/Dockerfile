FROM node:lts-slim
LABEL maintainer="Starbix"

ENV CUSTOMPLUGINS=""

COPY run.sh /root/run.sh

RUN apt-get update \
    && apt-get install  --no-install-recommends --no-install-suggests -y \
        libavahi-compat-libdnssd-dev \
        avahi-daemon \
        avahi-discover \
        libnss-mdns \
        build-essential \
    && npm install -g --unsafe-perm \
       homebridge \
       homebridge-hyperion \
       homebridge-plex-sensors \
    # && sed -i '/use-ipv6=yes/c\use-ipv6=no' /etc/avahi/avahi-daemon.conf \
    && sed -i '/#enable-dbus=yes/c\enable-dbus=yes' /etc/avahi/avahi-daemon.conf \
    && mkdir -p /var/run/dbus \
    && chmod +x /root/run.sh \
    && apt-get remove build-essential -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/*

VOLUME /config

HEALTHCHECK --interval=2m --timeout=5s \
  CMD curl http://localhost:51826/ || exit 1

EXPOSE 51826

CMD ["/root/run.sh"]
