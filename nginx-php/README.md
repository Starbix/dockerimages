<p align="center">
  <img width="50%" src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg">
</p>

## Description
What is [Nginx](http://nginx.org)?

nginx (engine x) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, nginx served or proxied 24.29% busiest sites in December 2015. Here are some of the success stories: Netflix, Wordpress.com, FastMail.FM.

What is [PHP](https://secure.php.net/)?

PHP is a popular general-purpose scripting language that is especially suited to web development.
Fast, flexible and pragmatic, PHP powers everything from your blog to the most popular websites in the world.


## BUILD IMAGE
### Build arguments
* BUILD_CORES : Number of cpu's core for compile (default : empty for use all cores)
* NGINX_VER : Nginx version (default : latest version)
* NGINX_GPG : Nginx gpg fingerprint
* NGINX_CONF : Nginx build arguments (default : see Dockerfile)
* PHP_VER : PHP version (default : latest version)
* PHP_MIRROR: Mirror for download PHP (default : http://ch1.php.net)
* PHP_GPG : PHP gpg fingerprint
* PHP_CONF : PHP build arguments (default : see Dockerfile)
* PHP_EXT_LIST : PHP extensions list, for install there (default : see Dockerfile)
* CUSTOM_BUILD_PKGS : Necessary packages for build PHP extension, there packages are remove after build (default : see Dockerfile)
* CUSTOM_PKGS : Necessary package for PHP extension (default : see Dockerfile)


## Configuration
### Environments
* UID : Choose uid for launch (default : 991)
* GID : Choose gid for launch (default : 991)

### Volumes
* /nginx/sites-enabled : Place your vhost here
* /nginx/log : Log emplacement
* /nginx/run : Here is pid and lock file
* /nginx/conf/nginx.conf : General configuration of nginx
* /nginx/conf.d : folder for other configuration (ex : php.conf, headers_param.conf)

if you mount /nginx/conf.d, use this php.conf :
```shell
location ~ \.php$ {
    fastcgi_index index.php;
    fastcgi_pass unix:/php/run/php-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include /nginx/conf/fastcgi_params;
}
```
