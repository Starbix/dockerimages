FROM alpine

ARG NEXTCLOUD_VERSION=13.0.4
ARG GPG_nextcloud="2880 6A87 8AE4 23A2 8372  792E D758 99B9 A724 937A"

ARG BUILD_CORES

ARG NGINX_VER=1.15.0
ARG PHP_VER=7.2.6
ARG LIBICONV_VERSION=1.15

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud v${NEXTCLOUD_VERSION}" \
      maintainer="Starbix <starbix@laubacher.io>" \
      php_version="PHP v$PHP_VER built from source" \
      nginx_version="nginx v$NGINX_VER built from source"

ARG PHP_MIRROR=http://ch1.php.net

ARG NGINX_CONF=" \
    --prefix=/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --http-log-path=/nginx/logs/access.log \
    --error-log-path=/nginx/logs/error.log \
    --pid-path=/nginx/run/nginx.pid \
    --lock-path=/nginx/run/nginx.lock \
    --with-threads \
    --with-file-aio \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module"

ARG PHP_CONF=" \
    --prefix=/usr \
    --libdir=/usr/lib/php \
    --datadir=/usr/share/php \
    --sysconfdir=/php/etc \
    --localstatedir=/php/var \
    --with-pear=/usr/share/php \
    --with-config-file-scan-dir=/php/conf.d \
    --with-config-file-path=/php \
    --with-pic \
    --disable-short-tags \
    --without-readline \
    --enable-bcmath=shared \
    --enable-fpm \
    --disable-cgi \
    --enable-mysqlnd \
    --enable-mbstring \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-iconv=/usr/local \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-webp-dir \
    --with-xpm-dir=no \
    --with-freetype-dir \
    --enable-gd-native-ttf \
    --disable-gd-jis-conv \
    --with-zlib"

ARG PHP_EXT_LIST=" \
    mysqli \
    ctype \
    dom \
    json \
    xml \
    mbstring \
    posix \
    xmlwriter \
    zip \
    zlib \
    sqlite3 \
    pdo_sqlite \
    pdo_pgsql \
    pdo_mysql \
    pcntl \
    curl \
    fileinfo \
    bz2 \
    intl \
    openssl \
    ldap \
    simplexml \
    pgsql \
    ftp \
    exif \
    gmp \
    imap"

ARG CUSTOM_BUILD_PKGS=" \
    freetype-dev \
    openldap-dev \
    gmp-dev \
    icu-dev \
    postgresql-dev \
    libpng-dev \
    libwebp-dev \
    gd-dev \
    libjpeg-turbo-dev \
    libxpm-dev \
    libedit-dev \
    libxml2-dev \
    libressl-dev \
    libbz2 \
    sqlite-dev \
    imagemagick-dev \
    imap-dev"

ARG CUSTOM_PKGS=" \
    freetype \
    openldap \
    gmp \
    bzip2-dev \
    icu \
    libpq \
    imagemagick \
    c-client"

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=25G \
    APC_SHM_SIZE=128M \
    OPCACHE_MEM_SIZE=128 \
    MEMORY_LIMIT=512M \
    CRON_PERIOD=15m \
    CRON_MEMORY_LIMIT=1g \
    TZ=Etc/UTC \
    DB_TYPE=sqlite3 \
    DOMAIN=localhost

COPY rootfs-nginx-php /

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    gnupg \
    tar \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    libtool \
    samba-dev \
    linux-headers \
    libtool \
    build-base \
    pcre-dev \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    pkgconf \
    curl-dev \
    ca-certificates \
    ${CUSTOM_BUILD_PKGS} \
 && apk add \
    libressl \
    ca-certificates \
    libsmbclient \
    tzdata \
    s6 \
    su-exec \
    curl \
    libedit \
    libxml2 \
    libwebp \
    gd \
    pcre \
    zlib \
    ${CUSTOM_PKGS} \
 && NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \

 ### Source downloading
  && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
  && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
  && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
  && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
  && wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz -O /tmp/libiconv-${LIBICONV_VERSION}.tar.gz \
  && mkdir -p /php/conf.d \
  && mkdir -p /usr/src \
  && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
  && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
  && tar xzf /tmp/libiconv-${LIBICONV_VERSION}.tar.gz -C /usr/src \

 ### NGINX installation
  && cd /usr/src/nginx-${NGINX_VER} \
  && ./configure --with-cc-opt="-O3 -fPIE -fstack-protector-strong" ${NGINX_CONF} \
  && make -j ${NB_CORES} \
  && make install \

 ### GNU Libiconv installation
  && cd /usr/src/libiconv-${LIBICONV_VERSION} \
  && ./configure --prefix=/usr/local \
  && make && make install && libtool --finish /usr/local/lib \

 ### PHP installation
  && mv /usr/src/php-${PHP_VER} /usr/src/php \
  && cd /usr/src/php \
  && ./configure CFLAGS="-O3 -fstack-protector-strong" ${PHP_CONF} \
  && make -j ${NB_CORES} \
  && make install \

 ### Strip, clean, install modules
  && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
  && make clean \
  && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
  && docker-php-ext-install ${PHP_EXT_LIST} \
  && mkdir -p /nginx/logs /nginx/run /php/php-fpm.d /php/logs /php/run /php/session \


 && pecl install \
    smbclient \
    apcu \
    redis \
    imagick \
 && echo "extension=smbclient.so" > /php/conf.d/smbclient.ini \
 && echo "extension=redis.so" > /php/conf.d/redis.ini \
 && mkdir /nextcloud \
 && cd /tmp \
 && NEXTCLOUD_TARBALL="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL} \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.sha512 \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.asc \
 && wget -q https://nextcloud.com/nextcloud.asc \
 && echo "Verifying both integrity and authenticity of ${NEXTCLOUD_TARBALL}..." \
 && CHECKSUM_STATE=$(echo -n $(sha512sum -c ${NEXTCLOUD_TARBALL}.sha512) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && gpg --import nextcloud.asc \
 && FINGERPRINT="$(LANG=C gpg --verify ${NEXTCLOUD_TARBALL}.asc ${NEXTCLOUD_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_nextcloud}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${NEXTCLOUD_TARBALL}..." \
 && tar xjf ${NEXTCLOUD_TARBALL} --strip 1 -C /nextcloud \
 && update-ca-certificates \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg /usr/src/*

COPY rootfs /

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /config /apps2 /nextcloud/themes

EXPOSE 8888

CMD ["run.sh"]
