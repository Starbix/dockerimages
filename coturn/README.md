# coturn
[![Docker Pulls](https://img.shields.io/docker/pulls/starbix/coturn.svg)](https://hub.docker.com/r/starbix/coturn)

[![](https://images.microbadger.com/badges/version/starbix/coturn.svg)](http://microbadger.com/images/starbix/coturn) [![](https://images.microbadger.com/badges/image/starbix/coturn.svg)](http://microbadger.com/images/starbix/coturn)

## Description
What is **[coturn](https://github.com/coturn/coturn)**?

The TURN Server is a VoIP media traffic NAT traversal server and gateway. It can be used as a general-purpose network traffic TURN server and gateway, too.

### Features
- Based on Alpine Linux.
- Automatic installation using environment variables.
- No root processes. Never.

### Environment variables
#### Required:

- **SECRET** : Static authentication secret value (a string) for TURN REST API only. *(default : none)*

#### Optional:

- **UID** : user id *(default : 991)*
- **GID** : group id *(default : 991)*
- **HOST** : IP coturn will listen on *(default : 0.0.0.0)*

### Port
- **3478** : coturn port
