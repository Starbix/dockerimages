FROM alpine:3.19

ARG BUILD_CORES
ENV UID=991 GID=991

ARG NGINX_VER=1.25.3
ARG OPENSSL_VERSION=3.2.0
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

LABEL description="Opinionated NGINX image based on Alpine" \
      maintainer="Starbix" \
      io.laubacher.version.nginx="NGINX v$NGINX_VER built from source" \
      io.laubacher.version.openssl="OpenSSL v$OPENSSL_VERSION from source"

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

ARG CUSTOM_BUILD_PKGS="\
    libmaxminddb-dev"

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
    bash \
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
    ca-certificates \
    libmaxminddb \
    libwebp \
    gd \
    pcre \
    zlib \
 && cd /tmp \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && OPENSSL_TARBALL="openssl-${OPENSSL_VERSION}.tar.gz" \
 && wget https://www.openssl.org/source/${OPENSSL_TARBALL} \
 && mkdir -p /usr/src \
 && tar xzf ${OPENSSL_TARBALL} -C /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
### modules
&& cd /tmp && git clone --recurse-submodules https://github.com/google/ngx_brotli --depth=1 \
&& cd ngx_brotli/deps/brotli \
&& mkdir out && cd out \
&& cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed .. \
&& cmake --build . --config Release --target brotlienc \
&& cd /tmp \
&& git clone https://github.com/openresty/headers-more-nginx-module --depth=1 \
&& git clone https://github.com/leev/ngx_http_geoip2_module \
### NGINX installation
 && cd /usr/src/nginx-${NGINX_VER} \
 && ./configure \
 --prefix=/nginx \
 --sbin-path=/usr/local/sbin/nginx \
 --http-proxy-temp-path=/proxy_temp \
 --with-cc-opt="-m64 -DTCP_FASTOPEN=23 -fuse-ld=gold --param=ssp-buffer-size=4 -gsplit-dwarf -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wno-deprecated-declarations" \
 --with-ld-opt="-m64 -Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections" \
 --with-openssl-opt='no-shared no-ssl3 no-tls1 no-tls1_1 no-comp no-idea no-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -DOPENSSL_NO_HEARTBEATS -O3 -fPIC -fstack-protector-strong -D_FORTIFY_SOURCE=2' \
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
 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && sync \
 && apk del ${BUILD_DEPS} \
 && apk cache clean \
 && rm -rf /tmp/* /usr/src/* \
 && mkdir -p /nginx/logs /nginx/client_body_temp /nginx/fastcgi_temp /nginx/scgi_temp /nginx/uwsgi_temp /nginx/run /proxy_temp \
 && chown -R ${UID}:${GID} /nginx/*

HEALTHCHECK --interval=2m --timeout=5s \
  CMD curl -f http://localhost:8000/ || exit 1

EXPOSE 8000 4430

CMD ["run.sh"]
