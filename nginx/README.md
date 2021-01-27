<p align="center">
  <img width="50%" src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg">
</p>

[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/nginx.svg)]()[![](https://images.microbadger.com/badges/image/starbix/nginx.svg)](https://microbadger.com/images/starbix/nginx)

## Description
#### What is [NGINX](https://nginx.org) ?

NGINX (engine x) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, NGINX served or proxied 24.29% busiest sites in December 2015. Here are some of the success stories: Netflix, Wordpress.com, FastMail.FM.

### What is [Brotli](https://github.com/google/brotli) ?

Brotli is a generic-purpose lossless compression algorithm that compresses data using a combination of a modern variant of the LZ77 algorithm, Huffman coding and 2nd order context modeling, with a compression ratio comparable to the best currently available general-purpose compression methods. It is similar in speed with deflate but offers more dense compression.

## BUILD IMAGE
### Build arguments
* BUILD_CORES : Number of cpu's core for compile (default : empty for use all cores)
* NGINX_VER : NGINX version (default : latest version)
* NGINX_GPG : NGINX gpg fingerprint
* NGINX_CONF : NGINX build arguments (default : see Dockerfile)
* CUSTOM_PKGS : Necessary packages for compiling (default : see Dockerfile)

### Simple build
```shell
docker build -t starbix/nginx github.com/Starbix/dockerimages.git#master:nginx/1.1.1
```

### Build with arguments
```shell
docker build -t starbix/nginx \
        --build-arg NGINX_VER=1.15.1 \
        --build-arg CUSTOM_BUILD_PKGS="freetype-dev gmp-dev" \
        --build-arg CUSTOM_PKGS="freetype gmp" \
        github.com/Starbix/dockerimages.git#master:nginx
```


## Configuration
### Environmental variables
* UID : Choose uid to launch NGINX and PHP (default : 991)
* GID : Choose gid to launch NGINX and PHP (default : 991)

### Volumes
* /sites-enabled : Place your vhost here
* /nginx/logs : Log emplacement
* /nginx/run : Here is pid and lock file
* /nginx/conf/nginx.conf : General configuration of NGINX
* /nginx/conf.d : folder for other configuration (ex : php.conf, headers_param.conf)

### Ports
* **HTTP:** 80
* **HTTPS:** 443

## Usage
### Simple launch
```shell
docker run -d -p 80:8000 starbix/nginx
```
URI access : http://XX.XX.XX.XX:8000

### Advanced launch
```shell
docker run -d -p 80:80 -p 443:443 \
	  -v /docker/nginx/sites-enabled:/sites-enabled \
      -v /docker/nginx/certs:/nginx/certs \
	  -e UID=1001 \
	  -e GID=1001 \
	starbix/nginx
```
URI access : http://XX.XX.XX.XX

## Contributing
Any contribution is very welcome !
