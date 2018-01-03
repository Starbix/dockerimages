<p align="center">
  <img width="50%" src="https://s31.postimg.org/8urk8vdu3/logobig.png">
</p>

[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/tvhproxy.svg)]()

[![](https://images.microbadger.com/badges/version/starbix/tvhproxy.svg)](https://microbadger.com/images/starbix/tvhproxy)
[![](https://images.microbadger.com/badges/image/starbix/tvhproxy.svg)](https://microbadger.com/images/starbix/tvhproxy)

## Description
What is [tvhproxy](https://github.com/jkaberg/tvhProxy)?

A small flask app to proxy requests between Plex Media Server and Tvheadend.

## Configuration

### Environmental variables
- `TVH_URL` = `http://username:password@192.168.1.255:9981`
- `TVH_TUNER_COUNT`= `4`

More [here](https://github.com/jkaberg/tvhProxy/blob/master/tvhProxy.py#L12)

### Ports
* 5004/tcp
* 5004/udp
