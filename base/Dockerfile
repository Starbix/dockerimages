FROM alpine:3.8

ARG GCC_VERSION=8.2.0

ARG GCC_CONF=" \
    --prefix=/gcc \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --build=x86_64-alpine-linux-musl \
    --host=x86_64-alpine-linux-musl \
    --target=x86_64-alpine-linux-musl \
    --with-pkgversion=\"Alpine ${GCC_VERSION}\" \
    --enable-checking=release \
    --disable-fixed-point \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-nls \
    --disable-werror \
    --disable-symvers \
    --enable-__cxa_atexit \
    --enable-default-pie \
    --enable-cloog-backend \
    --enable-languages=c,c++,objc \
    --disable-libssp \
    --disable-libmpx \
    --disable-libmudflap \
    --disable-libsanitizer \
    --enable-shared \
    --enable-threads \
    --enable-tls \
    --with-system-zlib \
    --with-linker-hash-style=gnu"

ENV PATH="/gcc/bin:${PATH}"

RUN apk --no-cache upgrade \
  && apk add --no-cache build-base zlib-dev \
  && mkdir -p /gcc \
  && cd /tmp \
  && wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz \
  && tar xf gcc-${GCC_VERSION}.tar.xz \
  && cd gcc-${GCC_VERSION} \
  && ./contrib/download_prerequisites --no-verify \
  && cd .. \
  && mkdir objdir \
  && cd objdir \
  && ./../gcc-${GCC_VERSION}/configure --prefix=/gcc \
  --mandir=/usr/share/man \
  --infodir=/usr/share/info \
  --build=x86_64-alpine-linux-musl \
  --host=x86_64-alpine-linux-musl \
  --target=x86_64-alpine-linux-musl \
  --with-pkgversion="Alpine ${GCC_VERSION}" \
  --enable-checking=release \
  --disable-fixed-point \
  --disable-libstdcxx-pch \
  --disable-multilib \
  --disable-nls \
  --disable-werror \
  --disable-symvers \
  --enable-__cxa_atexit \
  --enable-default-pie \
  --enable-cloog-backend \
  --enable-languages=c,c++,objc \
  --disable-libssp \
  --disable-libmpx \
  --disable-libmudflap \
  --disable-libsanitizer \
  --enable-shared \
  --enable-threads \
  --enable-tls \
  --with-system-zlib \
  --with-linker-hash-style=gnu \
  && make all-gcc \
  && make all-target-libgcc \
  && make install-gcc \
  && make install-target-libgcc \
  && make install-strip \
  && rm -rf /tmp/* /usr/share/man \
  && apk del --no-cache build-base zlib-dev


RUN ["sh"]
