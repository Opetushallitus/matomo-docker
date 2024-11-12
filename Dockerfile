FROM public.ecr.aws/docker/library/matomo:5.1.0
COPY --chown=www-data:www-data config.ini.php /var/www/html/config/config.ini.php