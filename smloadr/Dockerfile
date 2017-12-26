FROM alpine

COPY rootfs /

COPY SMLoadr /opt/SMLoadr

ENV UID=991 GID=991

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

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add shellinabox@testing nodejs nodejs-npm s6 su-exec \
    && cd /opt/SMLoadr \
    && ls \
    && npm install \
    && chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
    && rm -rf /var/cache/apk/*

EXPOSE 4200

VOLUME /opt/DeezLoadr/DOWNLOADS

CMD ["/usr/local/bin/run.sh"]
