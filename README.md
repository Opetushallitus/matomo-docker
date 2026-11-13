# matomo-docker
Dockerfile to create a custom matomo config that persist with container restart

### Update Matomo

Check Matomo version image index digest (multi-platform builds) and add it to the Dockerfile.
```
 export matomo_version='5.14.2'
```

```
 export matomo_version_digest=$(docker buildx imagetools inspect matomo:${matomo_version} --format '{{json .}}' | jq -rc '.manifest.digest')
```

```
 sed -i "s|^# matomo:.*|# matomo:${matomo_version}|g" Dockerfile
 sed -i "s|^FROM .*|FROM public.ecr.aws/docker/library/matomo@${matomo_version_digest}|g" Dockerfile
```

### Test build locally before pushing changes

```
 cp .env.template .env
```
Add values to '.env' file.

Generate config file.
```
 (set -a && source .env && set +a && envsubst <config.ini.php.template >config.ini.php)
```

Build image.
```
 docker build -t "matomo:${matomo_version}" .
```

Run image with local 'config.ini.php'.
```
 docker run --rm -it --name "matomo-${matomo_version}" -v "$PWD/config.ini.php:/var/www/html/config/config.ini.php" "matomo:${matomo_version}" bash
```
Check container and exit by pressing 'Ctrl + d'.

```
 docker rmi "matomo:${matomo_version}"
```

Push changes to git repo main branch, wait for GitHub Actions to build new image and finally update IaC with the new tag.

