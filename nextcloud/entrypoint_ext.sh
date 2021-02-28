installed=0
run_as 'php /var/www/html/occ status' | grep -q "installed: true" || installed=$?

if [ "${ENABLE_PUSH:-0}" -eq 1 ] && [ $installed -eq 0 ]; then
    installed_version="$(php -r 'require "/var/www/html/version.php"; echo implode(".", $OC_Version);')"
    echo "Installed version: $installed_version"
  
    if version_greater "$installed_version" "21.0.0.0"; then
        run_as 'php /var/www/html/occ app:list' | sed -n "/Enabled:/,/Disabled:/p" > /tmp/list_installed

        if grep -q "notify_push" /tmp/list_installed; then
            echo "notify_push already installed and enabled"
        else
            echo "Installing and enabling notify_push"
            run_as 'php /var/www/html/occ app:install notify_push'
            run_as 'php /var/www/html/occ app:enable notify_push'
        fi

        rm /tmp/list_installed

        sed -i '/^autostart=/c\autostart=true' /supervisord.conf

        if grep -q "#include" /etc/nginx/nginx.conf; then
            sed -i '/#include /c\       include /etc/nginx/nginx_push.conf;' /etc/nginx/nginx.conf
        fi

    else
        echo "notify_push only runs on Nextcloud 21 or higher"
        sed -i '/^autostart=/c\autostart=false' /supervisord.conf
    fi
else
    sed -i '/^autostart=/c\autostart=false' /supervisord.conf
fi

exec "$@"
