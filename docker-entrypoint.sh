#!/bin/sh
set -e

envsubst </var/www/html/config/config.ini.php.template >/var/www/html/config/config.ini.php
exec /entrypoint.sh "$@"
