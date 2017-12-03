FROM ubuntu:artful

COPY rootfs /

ENV SIAB_VERSION=2.19 \
  SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=guest \
  SIAB_USERID=991 \
  SIAB_GROUP=guest \
  SIAB_GROUPID=991 \
  SIAB_PASSWORD=putsafepasswordhere \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/opt/DeezLoadr \
  SIAB_SUDO=false \
  SIAB_SSL=false \
  SIAB_SERVICE=/:${USER}:${USER}:/opt/DeezLoadr:deez.sh \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

RUN apt-get update \
    && apt-get install -y shellinabox curl openssh-client nodejs npm git \
    && mkdir -p /opt \
    && cd /opt \
    && git clone https://github.com/J05HI/DeezLoadr \
    && cd DeezLoadr \
    && npm install \
    && cd /etc/shellinabox/options-available \
    && ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
    /etc/shellinabox/options-enabled/00+Black-on-White.css && \
  ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
    /etc/shellinabox/options-enabled/00_White-On-Black.css && \
  ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
    /etc/shellinabox/options-enabled/01+Color-Terminal.css \
    && chmod a+x /usr/local/bin/*


EXPOSE 4200

VOLUME /opt/DeezLoadr/DOWNLOADS

CMD ["/usr/local/bin/run.sh"]
