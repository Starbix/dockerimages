#!/bin/sh

sed -i -e "s/<TOKEN>/$TOKEN/g" /opt/LDAP-for-Plex/config/options.json \
       -e "s/<MACHINEID>/$MACHINEID/g" /opt/LDAP-for-Plex/config/options.json \
       -e "s/<SERVERNAME>/$SERVERNAME/g" /opt/LDAP-for-Plex/config/options.json \
       -e "s/<DEBUG>/$DEBUG/g" /opt/LDAP-for-Plex/config/options.json \
       -e "s/<PORT>/$PORT/g" /opt/LDAP-for-Plex/config/options.json \
       -e "s/<HOST>/$HOST/g" /opt/LDAP-for-Plex/config/options.json

echo "Updating permissions..."
for dir in /opt/LDAP-for-Plex /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
