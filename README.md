# dockerimages

> 🐳 Some Dockerfiles based on Alpine Linux

[![license](https://img.shields.io/github/license/starbix/dockerimages.svg)](https://github.com/Starbix/dockerimages)

## Dockerfiles

### [plex-ldap](https://github.com/Starbix/dockerimages/tree/master/plex-ldap)
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/plex-ldap.svg)](https://github.com/Starbix/dockerimages/tree/master/plex-ldap) [![](https://images.microbadger.com/badges/image/starbix/plex-ldap.svg)](https://microbadger.com/images/starbix/plex-ldap)
- An LDAP server that uses Plex as the provider
- Based on Alpine Linux
- Automatic installation using environment variables

### [NGINX](https://github.com/Starbix/dockerimages/tree/master/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/nginx.svg)](https://github.com/Starbix/dockerimages/tree/master/nginx) [![](https://images.microbadger.com/badges/image/starbix/nginx.svg)](https://microbadger.com/images/starbix/nginx)

**Notice: PHP will be removed in the future**
- NGINX + PHP + OpenSSL
- Built from source
- Based on Alpine Linux
- With [Brotli](https://github.com/google/brotli)


### [Nextcloud](https://github.com/Starbix/dockerimages/tree/master/nextcloud)
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/nextcloud.svg)](https://github.com/Starbix/dockerimages/tree/master/nextcloud) [![](https://images.microbadger.com/badges/image/starbix/nextcloud.svg)](https://microbadger.com/images/starbix/nextcloud)

**DEPRECATED: will soon not be maintained anymore or updated without backwards compatibility. Migrate to [the offical image](https://github.com/nextcloud/docker)**

- Continuation of [wonderfall/nextcloud](https://github.com/Wonderfall/dockerfiles/tree/master/nextcloud)
- Based on Alpine Linux
- Bundled with NGINX and PHP 7.3
- Automatic installation using environment variables

### [automarkwatched](https://github.com/Starbix/dockerimages/tree/master/automarkwatched)
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/automarkwatched.svg)](https://github.com/Starbix/dockerimages/tree/master/automarkwatched) [![](https://images.microbadger.com/badges/image/starbix/automarkwatched.svg)](https://microbadger.com/images/starbix/automarkwatched)
- A web application for marking TV shows as watched/unwatched for Plex Media Server
- Based on Alpine Linux

### [homebridge](https://github.com/Starbix/dockerimages/tree/master/homebridge)
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/homebridge.svg)](https://github.com/Starbix/dockerimages/tree/master/homebridge) [![](https://images.microbadger.com/badges/image/starbix/homebridge.svg)](https://microbadger.com/images/starbix/homebridge)

**Notice: not maintained anymore**
- Homebridge with the Hyperion Plugin
- Based on Debian
- More plugins via environmental variable

## Maintainers

[@Starbix](https://github.com/Starbix)

## Contribute

PRs accepted.

## License

MIT © 2021 Cédric Laubacher
