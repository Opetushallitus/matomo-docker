# matomo-docker
Dockerfile to create a custom matomo config that persist with container restart

### Update Matomo version

Check Matomo version image index digest (multi-platform builds) and add it to the Dockerfile.

Add Matomo version.
```
 export matomo_version='<major>.<minor>.<patch>'
```

Generate configs.
```
 ./generate-configs.sh
```

### Update Matomo configurations

Make changes to 'config.ini.php.template' file.

Generate '.env' file.
```
 awk '{while(match($0,/\$\{[A-Za-z_][A-Za-z0-9_]*\}/)){v=substr($0,RSTART+2,RLENGTH-3);if(!seen[v]++)print v"=";$0=substr($0,RSTART+RLENGTH)}}' config.ini.php.template >.env
```
Add values to '.env' file.

Generate config file and check values.
```
 (set -a && source .env && set +a && envsubst <config.ini.php.template >config.ini.php && cat config.ini.php)
```

### Test build locally before pushing changes

Test containers locally.
```
 ./test-locally.sh
```

Clean test resources.
```
 docker rmi "matomo:${matomo_version}"
 rm config.ini.php .env
```

Push changes to git repo main branch, wait for GitHub Actions to build new image and finally update IaC with the new tag.

