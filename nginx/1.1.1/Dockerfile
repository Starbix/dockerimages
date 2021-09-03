FROM alpine:3.14

ARG BUILD_CORES
ENV UID=991 GID=991

ARG NGINX_VER=1.21.2
ARG PHP_VER=7.4.23
ARG LIBICONV_VERSION=1.16
ARG OPENSSL_VERSION=1.1.1l
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

LABEL description="NGINX + PHP image based on Alpine" \
      maintainer="Starbix" \
      io.laubacher.version.php="PHP v$PHP_VER built from source" \
      io.laubacher.version.nginx="NGINX v$NGINX_VER built from source" \
      io.laubacher.version.openssl="OpenSSL v$OPENSSL_VERSION from source"

ARG PHP_MIRROR=https://secure.php.net
ARG GNU_MIRROR=https://mirror.init7.net

ARG NGINX_CONF=" \
    --with-http_auth_request_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
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
    --add-module=/tmp/ngx_http_geoip2_module"

ARG PHP_CONF=" \
    --prefix=/usr \
    --libdir=/usr/lib/php \
    --datadir=/usr/share/php \
    --sysconfdir=/php/etc \
    --localstatedir=/php/var \
    --with-pear=/usr/share/php \
    --with-config-file-scan-dir=/php/conf.d \
    --with-config-file-path=/php \
    --enable-option-checking=fatal \
    --with-pic \
    --disable-short-tags \
    --without-readline \
    --enable-bcmath=shared \
    --enable-fpm \
    --enable-mysqlnd \
    --enable-mbstring \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-iconv=/usr/local \
    --enable-gd \
    --with-jpeg \
    --with-webp \
    --with-freetype \
    --with-sqlite3 \
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
    pdo \
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
    session \
    tokenizer \
    gmp"

ARG CUSTOM_BUILD_PKGS=" \
    freetype-dev \
    openldap-dev \
    gmp-dev \
    icu-dev \
    oniguruma-dev \
    postgresql-dev \
    libpng-dev \
    libwebp-dev \
    gd-dev \
    libjpeg-turbo-dev \
    libedit-dev \
    libmaxminddb-dev \
    libxml2-dev \
    openssl-dev \
    bzip2-dev \
    libzip-dev \
    sqlite-dev"

ARG CUSTOM_PKGS=" \
    freetype \
    openldap \
    gmp \
    oniguruma \
    git \
    libbz2 \
    libzip \
    icu \
    sqlite-libs \
    libpq"

COPY rootfs /

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \
 && apk -U upgrade \
 && BUILD_DEPS=" \
    linux-headers \
    libtool \
    build-base \
    binutils-gold \
    bison \
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
    cmake \
    automake \
    file \
    patch \
    re2c \
    git \
    ${CUSTOM_BUILD_PKGS}" \
 && apk -U add \
    ${BUILD_DEPS} \
    s6 \
    su-exec \
    curl \
    libedit \
    libxml2 \
    openssl \
    libmaxminddb \
    libwebp \
    gd \
    pcre \
    zlib \
    ${CUSTOM_PKGS} \
### Source downloading
 # && export CC="/gcc/bin/gcc" \
 && cd /tmp \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
 && wget ${GNU_MIRROR}/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz -O /tmp/libiconv-${LIBICONV_VERSION}.tar.gz \
 && OPENSSL_TARBALL="openssl-${OPENSSL_VERSION}.tar.gz" \
 && wget https://www.openssl.org/source/${OPENSSL_TARBALL} \
 && mkdir -p /php/conf.d \
 && mkdir -p /usr/src \
 && tar xzf ${OPENSSL_TARBALL} -C /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
 && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
 && tar xzf /tmp/libiconv-${LIBICONV_VERSION}.tar.gz -C /usr/src \

### modules
&& cd /tmp && git clone --recurse-submodules https://github.com/google/ngx_brotli --depth=1 \
&& cd ngx_brotli/deps/brotli \
&& mkdir out && cd out \
&& ../configure-cmake && make -j ${NB_CORES} && make install && cd /tmp \
&& git clone https://github.com/openresty/headers-more-nginx-module --depth=1 \
&& git clone https://github.com/leev/ngx_http_geoip2_module \

# && cd /usr/src/openssl-${OPENSSL_VERSION} \
# && wget https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d_ciphers.patch \
# && patch -p1 < openssl-equal-1.1.1d_ciphers.patch \

### NGINX installation
 && cd /usr/src/nginx-${NGINX_VER} \
 && ./configure \
 --prefix=/nginx \
 --sbin-path=/usr/local/sbin/nginx \
 --with-cc-opt="-m64 -DTCP_FASTOPEN=23 -fuse-ld=gold --param=ssp-buffer-size=4 -gsplit-dwarf -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wno-deprecated-declarations" \
 --with-ld-opt="-lrt -Wl,-Bsymbolic-functions -Wl,-z,relro" \
 --with-openssl-opt='no-async enable-ec_nistp_64_gcc_128 no-shared no-ssl3 no-comp no-idea no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2' \
 --with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
 --http-log-path=/nginx/logs/nginx_access.log \
 --error-log-path=/nginx/logs/nginx_error.log \
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
 && make -j ${NB_CORES} && make install && libtool --finish /usr/local/lib \

### PHP installation
 && mv /usr/src/php-${PHP_VER} /usr/src/php \
 && cd /usr/src/php \
 && ./configure \
    CFLAGS="-O3 -fstack-protector-strong -fpie -fuse-ld=gold" \
    LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
    ${PHP_CONF} \
 && make -j ${NB_CORES} \
 && make install \
 && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && make clean \

### NGINX amplify
 # && cd /tmp \
 # && wget https://raw.githubusercontent.com/Starbix/nginx-amplify-agent/1.4/packages/install-source.sh \
 # && chmod u+x install-source.sh \
 # && ./install-source.sh \
 # && cd /usr/lib/python2.7/site-packages/nginx_amplify_agent-*-py2.7.egg/amplify/agent/managers \
 # && rm -rf abstract.py && wget https://raw.githubusercontent.com/Starbix/nginx-amplify-agent/master/amplify/agent/managers/abstract.py \
 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && sync \
 && docker-php-ext-install ${PHP_EXT_LIST} \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/* /gcc* \
 && mkdir -p /nginx/logs /nginx/client_body_temp /nginx/fastcgi_temp /nginx/proxy_temp /nginx/scgi_temp /nginx/uwsgi_temp /nginx/run /php/php-fpm.d /php/logs /php/run /php/session \
 && chown -R ${UID}:${GID} /nginx/*

HEALTHCHECK --interval=2m --timeout=5s \
  CMD curl -f http://localhost:8000/ || exit 1

EXPOSE 8000 4430

CMD ["run.sh"]
