NGINX_VER=1.19.6

OPENSSL_VERSION=1.1.1i

GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

NGINX_CONF=" \
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

NGINX_3RD_PARTY_MODULES=" \
    --add-module=/tmp/headers-more-nginx-module \
    --add-module=/tmp/ngx_brotli \
    --add-module=/tmp/ngx_http_geoip2_module"

NGINX_CC_OPT="fuse-ld=gold \
-O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat \
-Werror=format-security -Wno-deprecated-declarations \
-march=ivybridge"

NGINX_LD_OPT="-lrt -Wl,-Bsymbolic-functions -Wl,-z,relro"

OPENSSL_OPT="enable-ec_nistp_64_gcc_128 no-shared no-ssl3 no-comp no-idea no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2"

CUSTOM_BUILD_PKGS="libmaxminddb-dev "