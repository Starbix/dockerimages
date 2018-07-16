# UnicornFFMPEG
[![](https://images.microbadger.com/badges/image/starbix/unicorn-plex.svg)](http://microbadger.com/images/starbix/unicorn-plex)

## Description
What is **[UnicornFFMPEG](https://github.com/UnicornTranscoder/UnicornFFMPEG)**?

This software is a part of UnicornTranscoder project, it's a binary to replace the official Plex Transcoder, the binary will save parameters in your Redis database, the data will be used by UnicornTranscoder.

### Features
- Based on `plexinc/pms-docker`.
- Automatic installation using environment variables.
- No root processes. Never.

### Environment variables

- Same as in Plex

### Volumes
- /opt/UnicornFFMPEG/config.js : Where you set your Redis configuration and change Plex paths if it's necessary
- Same as in Plex

### Port

- Same as in Plex
