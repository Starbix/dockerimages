FROM alpine:3.12

ARG BUILD_CORES
ENV UID=991 GID=991

ARG NGINX_VER=1.19.6
ARG OPENSSL_VERSION=1.1.1i
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

LABEL description="NGINX image based on Alpine" \
      maintainer="Starbix" \
      io.laubacher.version.nginx="NGINX v$NGINX_VER built from source" \
      io.laubacher.version.openssl="OpenSSL v$OPENSSL_VERSION from source"

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

ARG NGINX_CC_OPT="fuse-ld=gold \
-O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat \
-Werror=format-security -Wno-deprecated-declarations \
-march=ivybridge"

ARG NGINX_LD_OPT="-lrt -Wl,-Bsymbolic-functions -Wl,-z,relro"

ARG OPENSSL_OPT="enable-ec_nistp_64_gcc_128 no-shared no-ssl3 no-comp no-idea no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2"

ENV CONFIG=" \
--prefix=/nginx \
--sbin-path=/usr/local/sbin/nginx \
--with-cc-opt=$NGINX_CC_OPT \
--with-ld-opt=$NGINX_LD_OPT \
--with-openssl-opt=${OPENSSL_OPT} \
--with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
--http-log-path=/nginx/logs/access.log \
--error-log-path=/nginx/logs/error.log \
--pid-path=/nginx/run/nginx.pid \
--lock-path=/nginx/run/nginx.lock \
${NGINX_CONF} ${NGINX_3RD_PARTY_MODULES}"

ARG CUSTOM_BUILD_PKGS="libmaxminddb-dev "
    # \
    # freetype-dev \
    # openldap-dev \
    # gmp-dev \
    # icu-dev \
    # oniguruma-dev \
    # postgresql-dev \
    # libpng-dev \
    # libwebp-dev \
    # gd-dev \
    # libjpeg-turbo-dev \
    # libedit-dev \
    # libmaxminddb-dev \
    # libxml2-dev \
    # openssl-dev \
    # bzip2-dev \
    # libzip-dev \
    # sqlite-dev"

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
 && cd /tmp \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && OPENSSL_TARBALL="openssl-${OPENSSL_VERSION}.tar.gz" \
 && wget https://www.openssl.org/source/${OPENSSL_TARBALL} \
 && mkdir -p /usr/src \
 && tar xzf ${OPENSSL_TARBALL} -C /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src 

### modules
RUN cd /tmp && git clone --recurse-submodules https://github.com/google/ngx_brotli --depth=1 \
&& cd ngx_brotli/deps/brotli \
&& mkdir out && cd out \
&& ../configure-cmake && make -j ${NB_CORES} && make install && cd /tmp \
&& git clone https://github.com/openresty/headers-more-nginx-module --depth=1 \
&& git clone https://github.com/leev/ngx_http_geoip2_module 

# && cd /usr/src/openssl-${OPENSSL_VERSION} \
# && wget https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1d_ciphers.patch \
# && patch -p1 < openssl-equal-1.1.1d_ciphers.patch \

### NGINX installation
 RUN cd /usr/src/nginx-${NGINX_VER} \
 && ./configure \
 --prefix=/nginx \
 --sbin-path=/usr/local/sbin/nginx \
 --with-cc-opt="$NGINX_CC_OPT" \
 --with-ld-opt="$NGINX_LD_OPT" \
 --with-openssl-opt="${OPENSSL_OPT}" \
 --with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
 --http-log-path=/nginx/logs/access.log \
 --error-log-path=/nginx/logs/error.log \
 --pid-path=/nginx/run/nginx.pid \
 --lock-path=/nginx/run/nginx.lock \
 ${NGINX_CONF} \
 ${NGINX_3RD_PARTY_MODULES} \
 && make -j ${NB_CORES} \
 && make install \
 && strip -s /usr/local/sbin/nginx \

 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && sync \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
 && mkdir -p /nginx/logs /nginx/client_body_temp /nginx/fastcgi_temp /nginx/proxy_temp /nginx/scgi_temp /nginx/uwsgi_temp /nginx/run \
 && chown -R ${UID}:${GID} /nginx/*

HEALTHCHECK --interval=2m --timeout=5s \
  CMD curl -f http://localhost:80/ || exit 1

EXPOSE 80 443

CMD ["run.sh"]
