# syntax=docker/dockerfile:1

FROM alpine:3.24 AS builder

# Build arguments
ARG BUILD_CORES
ARG NGINX_VER=1.31.8
ARG OPENSSL_VERSION=4.1.0
ARG MODSECURITY_VERSION=3.0.17
ARG CRS_VERSION=4.30.0
ARG LUAJIT2_VERSION=2.1-20250826
ARG LUA_NGINX_MODULE_VERSION=0.10.31
ARG LUA_RESTY_CORE_VERSION=0.1.34rc3
ARG LUA_RESTY_LRUCACHE_VERSION=0.15
ARG LUA_CJSON_VERSION=2.1.0.9
ARG LUA_RESTY_HTTP_VERSION=0.18.0
ARG LUA_RESTY_STRING_VERSION=0.19
ARG LUA_CS_BOUNCER_VERSION=1.0.19

# Build dependencies
RUN apk add --no-cache --virtual .build-deps \
    linux-headers \
    build-base \
    pcre-dev \
    pcre2-dev \
    zlib-dev \
    openssl-dev \
    wget \
    cmake \
    git \
    curl-dev \
    libmaxminddb-dev \
    libxml2-dev \
    yajl-dev \
    autoconf \
    automake \
    libtool \
    pkgconfig \
    patch \
    perl

WORKDIR /tmp
RUN wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz \
    && tar xzf nginx-${NGINX_VER}.tar.gz

RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && tar xzf openssl-${OPENSSL_VERSION}.tar.gz

RUN wget https://github.com/owasp-modsecurity/ModSecurity/releases/download/v${MODSECURITY_VERSION}/modsecurity-v${MODSECURITY_VERSION}.tar.gz \
    && tar xzf modsecurity-v${MODSECURITY_VERSION}.tar.gz

RUN wget https://github.com/coreruleset/coreruleset/archive/refs/tags/v${CRS_VERSION}.tar.gz \
    -O crs.tar.gz \
    && tar xzf crs.tar.gz \
    && mv coreruleset-${CRS_VERSION} crs

RUN git clone --depth=1 \
    https://github.com/openresty/headers-more-nginx-module.git \
    && git clone --depth=1 --recurse-submodules \
    https://github.com/google/ngx_brotli.git \
    && git clone --depth=1 \
    https://github.com/leev/ngx_http_geoip2_module.git \
    && git clone --depth=1 \
    https://github.com/owasp-modsecurity/ModSecurity-nginx.git

WORKDIR /tmp/ngx_brotli/deps/brotli
RUN mkdir out && cd out \
    && cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_FLAGS="-O3 -flto -march=x86-64-v2 -mtune=ivybridge" \
    -DCMAKE_CXX_FLAGS="-O3 -flto -march=x86-64-v2 -mtune=ivybridge" \
    .. \
    && cmake --build . --config Release --target brotlienc

# Configure and compile libmodsecurity
WORKDIR /tmp/modsecurity-v${MODSECURITY_VERSION}
RUN ./configure --prefix=/usr/local/modsecurity \
    && make -j${NB_CORES:-$(getconf _NPROCESSORS_CONF)} \
    && make install

# LuaJIT2 + Lua modules for the CrowdSec nginx bouncer
WORKDIR /tmp
RUN wget https://github.com/openresty/luajit2/archive/refs/tags/v${LUAJIT2_VERSION}.tar.gz \
    && tar xzf v${LUAJIT2_VERSION}.tar.gz \
    && make -C luajit2-${LUAJIT2_VERSION} -j${NB_CORES:-$(getconf _NPROCESSORS_CONF)} \
    && make -C luajit2-${LUAJIT2_VERSION} install PREFIX=/usr/local/luajit

RUN wget https://github.com/openresty/lua-nginx-module/archive/refs/tags/v${LUA_NGINX_MODULE_VERSION}.tar.gz \
    && tar xzf v${LUA_NGINX_MODULE_VERSION}.tar.gz \
    && mv lua-nginx-module-${LUA_NGINX_MODULE_VERSION} lua-nginx-module \
    && wget https://github.com/openresty/lua-resty-core/archive/refs/tags/v${LUA_RESTY_CORE_VERSION}.tar.gz \
    && tar xzf v${LUA_RESTY_CORE_VERSION}.tar.gz \
    && make -C lua-resty-core-${LUA_RESTY_CORE_VERSION} install LUA_LIB_DIR=/usr/local/share/lua/5.1 \
    && wget https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v${LUA_RESTY_LRUCACHE_VERSION}.tar.gz \
    && tar xzf v${LUA_RESTY_LRUCACHE_VERSION}.tar.gz \
    && make -C lua-resty-lrucache-${LUA_RESTY_LRUCACHE_VERSION} install LUA_LIB_DIR=/usr/local/share/lua/5.1 \
    && REQUIRED_MODULE=$(grep -oE "ngx_http_lua_module [0-9.]+" /usr/local/share/lua/5.1/resty/core/base.lua | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1) \
    && if [ "$REQUIRED_MODULE" != "$LUA_NGINX_MODULE_VERSION" ]; then echo "FATAL: lua-resty-core $LUA_RESTY_CORE_VERSION requires lua-nginx-module $REQUIRED_MODULE, but $LUA_NGINX_MODULE_VERSION is set - bump both together"; exit 1; fi \
    && wget https://github.com/openresty/lua-cjson/archive/refs/tags/${LUA_CJSON_VERSION}.tar.gz \
    && tar xzf ${LUA_CJSON_VERSION}.tar.gz \
    && make -C lua-cjson-${LUA_CJSON_VERSION} LUA_INCLUDE_DIR=/usr/local/luajit/include/luajit-2.1 \
    && make -C lua-cjson-${LUA_CJSON_VERSION} install \
        LUA_INCLUDE_DIR=/usr/local/luajit/include/luajit-2.1 \
        LUA_CMODULE_DIR=/usr/local/lib/lua/5.1 \
        LUA_MODULE_DIR=/usr/local/share/lua/5.1

# Assemble the CrowdSec nginx bouncer lua bundle
RUN git clone --depth=1 --branch v${LUA_CS_BOUNCER_VERSION} \
    https://github.com/crowdsecurity/lua-cs-bouncer.git \
    && git clone --depth=1 --branch v${LUA_RESTY_HTTP_VERSION} \
    https://github.com/ledgetech/lua-resty-http.git \
    && wget https://github.com/openresty/lua-resty-string/archive/refs/tags/v${LUA_RESTY_STRING_VERSION}.tar.gz \
    && tar xzf v${LUA_RESTY_STRING_VERSION}.tar.gz \
    && mkdir -p /usr/local/lua/crowdsec/resty /var/lib/crowdsec/lua/templates \
    && cp -r lua-cs-bouncer/lib/* /usr/local/lua/crowdsec/ \
    && cp lua-resty-http/lib/resty/*.lua /usr/local/lua/crowdsec/resty/ \
    && cp lua-resty-string-${LUA_RESTY_STRING_VERSION}/lib/resty/string.lua /usr/local/lua/crowdsec/resty/ \
    && cp -r lua-resty-string-${LUA_RESTY_STRING_VERSION}/lib/resty/string /usr/local/lua/crowdsec/resty/ 2>/dev/null || true \
    && cp lua-cs-bouncer/templates/* /var/lib/crowdsec/lua/templates/

# Configure and compile NGINX
WORKDIR /tmp/nginx-${NGINX_VER}
RUN LUAJIT_LIB=/usr/local/luajit/lib LUAJIT_INC=/usr/local/luajit/include/luajit-2.1 MODSECURITY_LIB=/usr/local/modsecurity/lib MODSECURITY_INC=/usr/local/modsecurity/include ./configure \
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
    --add-module=/tmp/ModSecurity-nginx \
    --add-module=/tmp/lua-nginx-module \
    --with-cc-opt='-O3 -flto -march=x86-64-v2 -mtune=ivybridge -fstack-protector-strong -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -ffunction-sections -fdata-sections' \
    --with-ld-opt='-Wl,-rpath,/usr/local/luajit/lib -Wl,-s -Wl,--gc-sections -Wl,-z,relro -Wl,-z,now'

# Compile NGINX
RUN NB_CORES=${BUILD_CORES:-$(getconf _NPROCESSORS_CONF)} \
    && make -j${NB_CORES} \
    && make install

# Production stage
FROM alpine:3.24

# Re-declare build args for use in this stage (defaults do not carry across stages)
ARG MODSECURITY_VERSION=3.0.17

# Runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    libmaxminddb \
    pcre \
    pcre2 \
    zlib \
    libxml2 \
    yajl \
    libstdc++ \
    tzdata \
    curl \
    s6 \
    su-exec \
    && addgroup -g 991 -S nginx \
    && adduser -S -D -H -u 991 -h /nginx -s /sbin/nologin -G nginx -g nginx nginx

# Copy NGINX binary and configuration from builder
COPY --from=builder /usr/local/sbin/nginx /usr/local/sbin/nginx
COPY --from=builder /nginx /nginx
COPY --from=builder /usr/local/modsecurity /usr/local/modsecurity
COPY --from=builder /usr/local/luajit /usr/local/luajit
COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua
COPY --from=builder /usr/local/lua/crowdsec /usr/local/lua/crowdsec
COPY --from=builder /var/lib/crowdsec/lua/templates /var/lib/crowdsec/lua/templates
COPY --from=builder /tmp/crs /nginx/conf/modsecurity/crs
COPY --from=builder /tmp/modsecurity-v${MODSECURITY_VERSION}/unicode.mapping /nginx/conf/modsecurity/unicode.mapping

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
    && cp /nginx/conf/modsecurity/crs/crs-setup.conf.example /nginx/conf/modsecurity/crs-setup.conf \
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
