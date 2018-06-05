#!/bin/bash

if [ "${CUSTOMPLUGINS}" != "" ]; then
  npm i -g ${CUSTOMPLUGINS}
fi

service dbus restart
avahi-daemon -D --no-chroot

homebridge -U /config
