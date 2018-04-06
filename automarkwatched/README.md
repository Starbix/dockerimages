# AutoMarkWatched
[![](https://images.microbadger.com/badges/version/starbix/automarkwatched.svg)](http://microbadger.com/images/starbix/automarkwatched) [![](https://images.microbadger.com/badges/image/starbix/automarkwatched.svg)](http://microbadger.com/images/starbix/automarkwatched)

## Description
What is **[AutoMarkWatched](https://github.com/DirtyCajunRice/AutoMarkWatched)**?

A web application for marking TV shows as watched/unwatched for Plex Media Server.

### Features
- Based on Alpine Linux.
- Automatic installation using environment variables.
- No root processes. Never.

### Environment variables
#### Required:

#### Optional:

- **SECRET_KEY** :  Backend to front end auth key *(default : auto-generated)*
- **UID** : user id *(default : 991)*
- **GID** : group id *(default : 991)*
- **DEBUG** : enable debug *(default : False)*
- **PORT** : port for AutoMarkWatched Webinterface *(default : 8000)*
- **HOST** : IP AutoMarkWatched will listen on *(default : 0.0.0.0)*

### Port

- **8000** : Webinterface port
