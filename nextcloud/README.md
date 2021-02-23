<p align="center">
  <img width="50%" src="https://upload.wikimedia.org/wikipedia/commons/6/60/Nextcloud_Logo.svg">
</p>

[![](https://images.microbadger.com/badges/version/starbix/nextcloud.svg)](http://microbadger.com/images/starbix/nextcloud) [![](https://images.microbadger.com/badges/image/starbix/nextcloud.svg)](http://microbadger.com/images/starbix/nextcloud)


### Features
- Based on Alpine Linux.
- Automatic installation using environment variables.
- system cron task running.
- optional [notify_push](https://github.com/nextcloud/notify_push) app

### Tags
- **latest** : latest stable version

### Configuration

You can use the environmental variables described [here](https://github.com/nextcloud/docker#auto-configuration-via-environment-variables)

#### Custom Variables
- **ENABLE_PUSH**: 0
  - [notify_push](https://github.com/nextcloud/notify_push) can be enabled by setting ENABLE_PUSH=1
  - Remark: Redis is required for this functionality
