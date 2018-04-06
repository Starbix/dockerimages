#!/bin/sh

sed -i -e "s/localhost/$HOST/g" /opt/AutoMarkWatched/automarkwatched/settings.py \
       -e "/DEBUG/c\DEBUG = $DEBUG" /opt/AutoMarkWatched/automarkwatched/settings.py

if [ ! -f /config/secretkey ]; then
  python3 /opt/AutoMarkWatched/generate_secret_key.py > /config/secretkey
fi

sed -i -e '/SECRET_KEY/c\SECRET_KEY = '\'`cat /config/secretkey`\' /opt/AutoMarkWatched/automarkwatched/settings.py

python3 /opt/AutoMarkWatched/manage.py migrate

echo "Updating permissions..."
for dir in /opt/AutoMarkWatched /etc/s6.d /config; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
