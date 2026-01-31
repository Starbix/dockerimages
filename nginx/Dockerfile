# syntax=docker/dockerfile:1

FROM alpine:3.23 AS builder

# Build arguments
ARG BUILD_CORES
ARG NGINX_VER=1.29.4
ARG OPENSSL_VERSION=3.6.1

# Build dependencies
RUN apk add --no-cache --virtual .build-deps \
    linux-headers \
    build-base \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    wget \
    cmake \
    git \
    curl-dev \
    libmaxminddb-dev \
    patch \
    perl

WORKDIR /tmp
RUN wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz \
    && tar xzf nginx-${NGINX_VER}.tar.gz

RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && tar xzf openssl-${OPENSSL_VERSION}.tar.gz

RUN git clone --depth=1 \
        https://github.com/openresty/headers-more-nginx-module.git \
    && git clone --depth=1 --recurse-submodules \
        https://github.com/google/ngx_brotli.git \
    && git clone --depth=1 \
        https://github.com/leev/ngx_http_geoip2_module.git

WORKDIR /tmp/ngx_brotli/deps/brotli
RUN mkdir out && cd out \
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_C_FLAGS="-O3 -flto -march=x86-64-v2 -mtune=ivybridge" \
        -DCMAKE_CXX_FLAGS="-O3 -flto -march=x86-64-v2 -mtune=ivybridge" \
        .. \
    && cmake --build . --config Release --target brotlienc

# Configure and compile NGINX
WORKDIR /tmp/nginx-${NGINX_VER}
RUN ./configure \
    --prefix=/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --conf-path=/nginx/conf/nginx.conf \
    --error-log-path=/nginx/logs/error.log \
    --http-log-path=/nginx/logs/access.log \
    --pid-path=/nginx/run/nginx.pid \
    --lock-path=/nginx/run/nginx.lock \
    --http-client-body-temp-path=/nginx/temp/client_temp \
    --http-proxy-temp-path=/nginx/temp/proxy_temp \
    --http-fastcgi-temp-path=/nginx/temp/fastcgi_temp \
    --http-uwsgi-temp-path=/nginx/temp/uwsgi_temp \
    --http-scgi-temp-path=/nginx/temp/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-pcre-jit \
    --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
    --with-openssl-opt='no-tests no-shared no-ssl3 no-tls1-method no-tls1_1-method no-comp no-idea no-weak-ssl-ciphers no-legacy no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 no-des no-dsa -DOPENSSL_NO_HEARTBEATS -O3 -flto -march=x86-64-v2 -mtune=ivybridge' \
    --with-threads \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_sub_module \
    --with-http_stub_status_module \
    --without-http_geo_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module \
    --add-module=/tmp/headers-more-nginx-module \
    --add-module=/tmp/ngx_brotli \
    --add-module=/tmp/ngx_http_geoip2_module \
    --with-cc-opt='-O3 -flto -march=x86-64-v2 -mtune=ivybridge -fstack-protector-strong -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -ffunction-sections -fdata-sections' \
    --with-ld-opt='-Wl,-s -Wl,--gc-sections -Wl,-z,relro -Wl,-z,now'

# Compile NGINX
RUN NB_CORES=${BUILD_CORES:-$(getconf _NPROCESSORS_CONF)} \
    && make -j${NB_CORES} \
    && make install

# Production stage
FROM alpine:3.22

# Runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    libmaxminddb \
    pcre \
    zlib \
    tzdata \
    curl \
    s6 \
    su-exec \
    && addgroup -g 991 -S nginx \
    && adduser -S -D -H -u 991 -h /nginx -s /sbin/nologin -G nginx -g nginx nginx

# Copy NGINX binary and configuration from builder
COPY --from=builder /usr/local/sbin/nginx /usr/local/sbin/nginx
COPY --from=builder /nginx /nginx

# Copy configuration files
COPY rootfs /

# Create necessary directories and set permissions
RUN mkdir -p \
    /nginx/logs \
    /nginx/temp/client_temp \
    /nginx/temp/proxy_temp \
    /nginx/temp/fastcgi_temp \
    /nginx/temp/uwsgi_temp \
    /nginx/temp/scgi_temp \
    /nginx/run \
    && chown -R nginx:nginx /nginx \
    && chmod +x /usr/local/bin/* \
    && find /etc/s6.d -name run -exec chmod +x {} \; \
    && find /etc/s6.d -name finish -exec chmod +x {} \;

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# Expose ports
EXPOSE 8000 4430

# Start command
CMD ["run.sh"]
