FROM alpine:edge

RUN apk add -U build-base linux-vanilla-dev libmnl-dev \
    && mkdir -p /opt && cd /opt \
    && wget https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181018.tar.xz \
    && cd WireGuard/src \
    && make \
    && make install
