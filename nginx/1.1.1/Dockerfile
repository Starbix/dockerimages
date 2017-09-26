FROM alpine:3.6

ARG BUILD_CORES
ENV UID=991 GID=991

ARG NGINX_VER=1.13.5
ARG PHP_VER=7.1.9
ARG LIBICONV_VERSION=1.15
ARG OPENSSL_VERSION=1.1.1
ARG PAGESPEED_VERSION=1.12.34.2-stable
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

LABEL description="nginx + php image based on Alpine" \
      maintainer="Starbix" \
      php_version="PHP v$PHP_VER built from source" \
      nginx_version="nginx v$NGINX_VER built from source" \
      openssl_version="Openssl v$OPENSSL_VERSION from source"

ARG PHP_MIRROR=http://ch1.php.net

ARG NGINX_CONF=" \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-file-aio \
    --with-pcre-jit \
    --without-http_geo_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module"

ARG NGINX_3RD_PARTY_MODULES=" \
    --add-module=/tmp/headers-more-nginx-module \
    --add-module=/tmp/ngx_brotli \
    --add-module=/tmp/nginx-ct"
    # --add-module=/tmp/ngx_pagespeed-${PAGESPEED_VERSION}"

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
    mcrypt \
    openssl \
    ldap \
    simplexml \
    pgsql \
    ftp \
    exif \
    gmp"

ARG CUSTOM_BUILD_PKGS=" \
    freetype-dev \
    openldap-dev \
    gmp-dev \
    libmcrypt-dev \
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
    sqlite-dev"

ARG CUSTOM_PKGS=" \
    freetype \
    openldap \
    gmp \
    libmcrypt \
    bzip2-dev \
    icu \
    libpq"

COPY rootfs /

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \

### Packages installation
 && BUILD_DEPS=" \
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
    git \
    automake \
    file \
    jemalloc-dev \
    patch \
    ${CUSTOM_BUILD_PKGS}" \
 && apk -U add \
    ${BUILD_DEPS} \
    s6 \
    su-exec \
    curl \
    jemalloc \
    libedit \
    libxml2 \
    libressl \
    libwebp \
    gd \
    pcre \
    zlib \
    ${CUSTOM_PKGS} \

### Source downloading
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
 && wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz -O /tmp/libiconv-${LIBICONV_VERSION}.tar.gz \
 # && OPENSSL_TARBALL="openssl-${OPENSSL_VERSION}.tar.gz" \
 # && wget https://www.openssl.org/source/${OPENSSL_TARBALL} \
 && mkdir -p /php/conf.d \
 && mkdir -p /usr/src \
 # && tar xzf ${OPENSSL_TARBALL} -C /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
 && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
 && tar xzf /tmp/libiconv-${LIBICONV_VERSION}.tar.gz -C /usr/src \

### openssl
&& cd /usr/src \
&& git clone --recursive https://github.com/openssl/openssl \
&& cd openssl \
# && wget https://raw.githubusercontent.com/cloudflare/sslconfig/master/patches/openssl__1.1.0_chacha20_poly1305.patch \
# && patch -p1 < openssl__1.1.0_chacha20_poly1305.patch \

### modules
&& cd /tmp && git clone https://github.com/bagder/libbrotli --depth=1 \
&& cd libbrotli && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
&& cd /tmp && git clone https://github.com/google/ngx_brotli --depth=1 \
&& cd ngx_brotli && git submodule update --init && cd /tmp \
&& git clone https://github.com/openresty/headers-more-nginx-module --depth=1 \
&& git clone https://github.com/grahamedgecombe/nginx-ct --depth=1 \
#
# && wget https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}.tar.gz \
# && tar xzvf v${PAGESPEED_VERSION}.tar.gz \
# && cd ngx_pagespeed-${PAGESPEED_VERSION}/ \
# && PAGESPEED_RELEASE_NUMBER=${PAGESPEED_VERSION/beta/} \
# && PAGESPEED_RELEASE_NUMBER=${PAGESPEED_VERSION/stable/} \
# && psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz \
# && [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL) \
# && wget ${psol_url} \
# && tar -xzvf $(basename ${psol_url}) \

### nginx installation
 && cd /usr/src/nginx-${NGINX_VER} \
 # Nginx patch : dynamic TLS records
 && wget https://gist.githubusercontent.com/SoftCreatR/b5047bda93e10ef048c7f7d4ffba3ec6/raw/d1e25c13769631303a651a8a8b08aa91befd73d5/nginx_1.13.5_sslconfig_combined.patch \
 && patch -p1 < nginx_1.13.5_sslconfig_combined.patch \
 && ./configure \
 --prefix=/nginx \
 --sbin-path=/usr/local/sbin/nginx \
 --with-cc-opt="-O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wno-deprecated-declarations" \
 --with-ld-opt="-lrt -ljemalloc -Wl,-Bsymbolic-functions -Wl,-z,relro" \
 --with-openssl-opt='no-async enable-ec_nistp_64_gcc_128 no-shared no-ssl2 no-ssl3 no-comp no-idea no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2' \
 --with-openssl=/usr/src/openssl \
 --http-log-path=/nginx/log/nginx_access.log \
 --error-log-path=/nginx/log/nginx_error.log \
 --pid-path=/nginx/run/nginx.pid \
 --lock-path=/nginx/run/nginx.lock \
${NGINX_CONF} \
${NGINX_3RD_PARTY_MODULES} \

 && make -j ${NB_CORES} \
 && make install && make clean \
 && strip -s /usr/local/sbin/nginx \

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
 && sync \
 && docker-php-ext-install ${PHP_EXT_LIST} \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
 && mkdir -p /nginx/logs /nginx/run /php/php-fpm.d /php/logs /php/run /php/session

CMD ["run.sh"]
