# LDAP for Plex
[![](https://images.microbadger.com/badges/version/starbix/plex-ldap.svg)](http://microbadger.com/images/starbix/plex-ldap) [![](https://images.microbadger.com/badges/image/starbix/plex-ldap.svg)](http://microbadger.com/images/starbix/plex-ldap)

## Description
What is **[LDAP for Plex](https://github.com/hjone72/LDAP-for-Plex)**?

An LDAP server that uses Plex as the provider.

### Features
- Based on Alpine Linux.
- Automatic installation using environment variables.
- No root processes. Never.

### Environment variables
#### Required:

- **TOKEN** : [Plex token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/) *(default : none)*
- **MACHINEID** : Plex machine identifier *(default : none)*
- **SERVERNAME** : Plex servername *(default : none)*

#### Optional:

- **UID** : user id *(default : 991)*
- **GID** : group id *(default : 991)*
- **DEBUG** : enable debug *(default : false)*
- **PORT** : port for the LDAP server *(default : 2389)*
- **HOST** : IP the LDAP server will listen on *(default : 0.0.0.0)*

### Port
- **2389** : LDAP port
