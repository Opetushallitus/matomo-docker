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

Generate config file and check values.
```
 (set -a && source .env && set +a && envsubst <config.ini.php.template >config.ini.php && cat config.ini.php)
```

Build image.
```
 docker build -t "matomo:${matomo_version}" .
```

Run temporary container, generate 'config.ini.php' inside container and check values.
```
 docker run --rm -it --name "matomo-${matomo_version}" --env-file .env "matomo:${matomo_version}" bash -c 'envsubst <config/config.ini.php.template >config/config.ini.php && cat config/config.ini.php'
```

Clean local resources.
```
 docker rmi "matomo:${matomo_version}"
 rm config.ini.php .env
```

Push changes to git repo main branch, wait for GitHub Actions to build new image and finally update IaC with the new tag.

