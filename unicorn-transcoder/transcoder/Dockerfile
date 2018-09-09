FROM frolvlad/alpine-glibc
LABEL maintainer="Starbix"

ENV UID=991 GID=991

ENV PORT=3000 \
	MOUNT_POINT="/mnt/acd" \
	TRANSCODER_DECAY_TIME=120 \
	PLEX_URL="http://myplex.com:32400" \
	BASE_URL="https://myplex.com" \
	REDIS_HOST="127.0.0.1" \
	REDIS_PORT=6379 \
	REDIS_PASSWORD="" \
	REDIS_DB=1 \
	VIDEO_CONTENT_TYPE="video/x-matroska" \
	SUBTITLES_CONTENT_TYPE="text/vtt" \
	LD_LIBRARY_PATH="/opt/UnicornTranscoder/Resources/" \
	TRANSCODER_PATH="/opt/UnicornTranscoder/Resources/Plex Transcoder" \
	FFMPEG_EXTERNAL_LIBS="/opt/UnicornTranscoder/Codecs/" \
	EAE_ROOT="/opt/UnicornTranscoder/Cache/" \
	XDG_CACHE_HOME="/opt/UnicornTranscoder/Cache/" \
	XDG_DATA_HOME="/opt/UnicornTranscoder/Resources/Resources/" \
	PLEX_RESSOURCES="/opt/UnicornTranscoder/Resources/"


ARG PLEX_VERSION="1.13.4.5251-2e6e8f841"
ARG CODEC_BUILD="e944d3a-1309"
ARG DEP="141"

COPY rootfs /

RUN apk add -U \
		npm \
		git \
		su-exec \
		s6 \
		binutils \
	&& mkdir -p /opt \
	&& cd /opt \
	&& git clone https://github.com/UnicornTranscoder/UnicornTranscoder \
	&& cd UnicornTranscoder \
	&& npm install \
	&& ./setup_transcode.sh "https://downloads.plex.tv/plex-media-server/${PLEX_VERSION}/plexmediaserver_${PLEX_VERSION}_amd64.deb" \
	&& mkdir -p ${FFMPEG_EXTERNAL_LIBS} \
	&& cd ${FFMPEG_EXTERNAL_LIBS} \
	# https://github.com/kayrus/plex/blob/master/README.md
	&& for codec in libhevc_decoder libh264_decoder libdca_decoder libac3_decoder libmp3_decoder libmp2_decoder libaac_decoder libaac_encoder libmpeg4_decoder libmsmpeg4v3_decoder libmpeg2video_decoder liblibmp3lame_encoder liblibx264_encoder libflv_decoder libpcm_bluray_decoder libvc1_decoder libvp8_decoder libwmav2_decoder libwmv2_decoder libvp9_decoder ; do \
	 wget https://downloads.plex.tv/codecs/${CODEC_BUILD}/linux-ubuntu-x86_64/${codec}.so; done \
	&& cd /opt/UnicornTranscoder \
	&& wget https://downloads.plex.tv/codecs/${DEP}/linux-ubuntu-x86_64/EasyAudioEncoder-linux-ubuntu-x86_64.zip \
	&& unzip EasyAudioEncoder-linux-ubuntu-x86_64.zip \
	&& mv EasyAudioEncoder/EasyAudioEncoder /opt/UnicornTranscoder/Codecs/ \
	&& rm -rf EasyAudioEncoder EasyAudioEncoder-linux-ubuntu-x86_64.zip \
	&& mkdir -p ${EAE_ROOT} \
	# Set permissions
	&& chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
	# Cleanup
	&& apk del git \
	&& rm -rf /tmp/* /var/cache/apk/*

EXPOSE 3000

CMD ["run.sh"]
