<p align="center">
  <img width="256" height="256" src="https://raw.githubusercontent.com/lidarr/Lidarr/develop/Logo/512.png">
</p>

[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/lidarr.svg)]()

[![](https://images.microbadger.com/badges/version/starbix/lidarr.svg)](https://microbadger.com/images/starbix/lidarr)
[![](https://images.microbadger.com/badges/image/starbix/lidarr.svg)](https://microbadger.com/images/starbix/lidarr)

## Description
What is [Lidarr](http://lidarr.audio)?

Looks and smells like Sonarr but made for music.

## Configuration
### Environments
* UID : Choose uid for launch lidarr (default : 991)
* GID : Choose gid for launch lidarr (default : 991)

### Volumes
* /config : General configuration of lidarr
* /media (or whatever folder you choose): Where Lidarr will download the music to

### Ports
* 8686
