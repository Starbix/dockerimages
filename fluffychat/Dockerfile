FROM cirrusci/flutter:stable AS builder
WORKDIR /opt

RUN git clone https://gitlab.com/famedly/fluffychat.git

WORKDIR /opt/fluffychat

RUN ./scripts/prepare-web.sh

RUN flutter build web --release


FROM nginx:alpine AS base

WORKDIR /usr/share/nginx/html

COPY --from=builder /opt/fluffychat/build/web/ .
COPY --from=builder /opt/fluffychat/config.sample.json config.json

EXPOSE 80