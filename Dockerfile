# matomo:5.14.3
FROM docker.io/library/matomo@sha256:ba13c4fc70f67c5b68a441cba06ae12904e58318ba86fcbf6603bd4bf5ee35c6
RUN apt-get update \
&& apt-get install -y --no-install-recommends curl gettext-base \
&& rm -rf /var/lib/apt/lists/*
COPY --chown=www-data:www-data config.ini.php.template /var/www/html/config/config.ini.php.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
&& curl -fsSL "https://download.db-ip.com/free/dbip-city-lite-$(date +%Y)-$(date +%m).mmdb.gz" --output ./dbip-city-lite.mmdb.gz \
&& gzip -d ./dbip-city-lite.mmdb.gz \
&& install -d -m 0755 -o www-data -g www-data /var/www/html/misc \
&& mv ./dbip-city-lite.mmdb /var/www/html/misc/DBIP-City.mmdb
COPY ./security/. /var/www/html/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
