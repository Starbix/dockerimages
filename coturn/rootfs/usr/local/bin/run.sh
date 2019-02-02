#!/bin/sh

if [ ! -f /config/turnserver.conf ]; then
    echo "Config not found!"
    echo "Using standard config"
    mkdir -p /config
    cp /opt/coturn/standard-coturn.conf /config/turnserver.conf
    if [ -z "$SECRET" ]; then
      SECRET=`openssl rand -hex 16`
      echo "Using secret: $SECRET"
    fi
    sed -i 's/SECRET_HERE/'"$SECRET"'/g' /config/turnserver.conf

    if [ -z "$DOMAIN" ]; then
      DOMAIN=`hostname`
      echo "Using realm: $DOMAIN"
    fi
    sed -i 's/DOMAIN_HERE/'"$DOMAIN"'/g' /config/turnserver.conf
fi

echo "Updating permissions..."
for dir in /config /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
