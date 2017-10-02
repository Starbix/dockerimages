FROM debian:jessie

RUN apt-get update && apt-get install -y curl \
    && curl -Ls https://get.cloud.docker.com/ | sh -s

CMD ["service", "dockercloud-agent", "start"]

VOLUME /etc/dockercloud

EXPOSE 2375 6783
