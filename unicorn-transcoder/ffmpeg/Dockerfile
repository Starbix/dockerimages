FROM node:latest

WORKDIR /opt

RUN git clone https://github.com/UnicornTranscoder/UnicornFFMPEG \
		&& cd UnicornFFMPEG \
		&& npm install pgk@4.3.3 \

FROM plexinc/pms-docker:latest

RUN apt-get update \
		&& apt-get install git npm \
		&& cd /opt \
		&& git clone https://github.com/UnicornTranscoder/UnicornFFMPEG \
		&& cd UnicornFFMPEG \
		&& npm install




		&& apt-get uninstall git npm
