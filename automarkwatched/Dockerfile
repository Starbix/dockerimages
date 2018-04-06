FROM alpine
LABEL maintainer="Starbix"

ENV UID=991
ENV GID=991

ENV PORT=8000

ENV HOST="*"

ENV DEBUG="False"

VOLUME /config

COPY rootfs /

RUN apk add -U s6 su-exec python3 git \
		&& mkdir -p /opt \
		&& cd /opt \
		&& git clone https://github.com/DirtyCajunRice/AutoMarkWatched \
		&& cd AutoMarkWatched \
		&& pip3 install -r requirements.txt \
		&& sed -i -e "s/SECRET_KEY = \'\'/SECRET_KEY = \'`python3 generate_secret_key.py`\'/g" automarkwatched/settings.py \
		&& sed -i -e "/'NAME': os.path.join/c\        'NAME': os.path.join('/config', 'automarkwatched.db')," automarkwatched/settings.py \
		&& python3 manage.py migrate \
		&& apk del git \
		&& rm -rf /tmp/* /var/cache/apk/* \
		&& chmod a+x /usr/local/bin/* /etc/s6.d/*/*

EXPOSE 8000

CMD ["run.sh"]
