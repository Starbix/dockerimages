FROM plexinc/pms-docker:latest

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
	&& apt-get install -y git nodejs \
	&& cd /opt \
	&& git clone https://github.com/UnicornTranscoder/UnicornFFMPEG \
	&& cd UnicornFFMPEG \
	&& npm install --only=production \
	&& apt-get uninstall git \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

COPY rootfs /
