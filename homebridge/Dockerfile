FROM node:latest
LABEL maintainer="Starbix"

ENV CUSTOMPLUGINS=""

COPY run.sh /root/run.sh

RUN apt-get update \
    && apt-get install  --no-install-recommends --no-install-suggests -y \
        libavahi-compat-libdnssd-dev \
        avahi-daemon \
        avahi-discover \
        libnss-mdns \
    && npm install -g --unsafe-perm \
       homebridge \
       homebridge-hyperion \
    # && sed -i '/use-ipv6=yes/c\use-ipv6=no' /etc/avahi/avahi-daemon.conf \
    && sed -i '/#enable-dbus=yes/c\enable-dbus=yes' /etc/avahi/avahi-daemon.conf \
    && mkdir -p /var/run/dbus \
    && chmod +x /root/run.sh \
    && rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 51826

VOLUME /config

CMD ["/root/run.sh"]
