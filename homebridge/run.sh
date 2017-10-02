#!/bin/bash

service dbus restart
avahi-daemon -D --no-chroot

homebridge -U /config
