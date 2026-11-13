# matomo:5.14.2
FROM public.ecr.aws/docker/library/matomo@sha256:db40a508196ba5327a53dcae07d12835e50c7764bdaae3ea7822c35d432e64dc
RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*
COPY --chown=www-data:www-data config.ini.php.template /var/www/html/config/config.ini.php.template
RUN curl https://download.db-ip.com/free/dbip-city-lite-$(date +%Y)-$(date +%m).mmdb.gz --output ./dbip-city-lite.mmdb.gz
RUN gzip -d ./dbip-city-lite.mmdb.gz
RUN install -d -m 0755 -o www-data -g www-data /var/www/html/misc
RUN mv ./dbip-city-lite.mmdb /var/www/html/misc/DBIP-City.mmdb
COPY ./security/. /var/www/html/
