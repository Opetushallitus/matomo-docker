FROM public.ecr.aws/docker/library/matomo:5.1.0
COPY --chown=www-data:www-data config.ini.php /var/www/html/config/config.ini.php
RUN curl https://download.db-ip.com/free/dbip-city-lite-$(date +%Y)-$(date +%m).mmdb.gz --output ./dbip-city-lite.mmdb.gz
RUN gzip -d ./dbip-city-lite.mmdb.gz
RUN install -d -m 0755 -o www-data -g www-data /var/www/html/misc
RUN mv ./dbip-city-lite.mmdb /var/www/html/misc/DBIP-City.mmdb
COPY ./security/. /var/www/html/
