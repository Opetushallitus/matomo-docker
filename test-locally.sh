#!/usr/bin/env sh

set -eu

image_name="matomo:${matomo_version}"

docker buildx build --platform linux/amd64,linux/arm64 -t "${image_name}" . && clear

for architecture in 'amd64' 'arm64'; do
	container_name="matomo-${matomo_version}-${architecture}"
	printf '\n####### Starting %s\n' "${container_name}" &&
	[ "$(docker inspect -f '{{.State.Running}}' "${container_name}" 2>/dev/null)" = true ] && docker stop "${container_name}" -t1 >/dev/null
	docker run --platform "linux/${architecture}" -d --rm -it --name "${container_name}" --env-file .env "${image_name}" >/dev/null &&
	sleep 2 &&
	printf '\n####### %s logs\n' "${container_name}" &&
	docker logs "${container_name}" &&
	printf '\n####### %s config.ini.php\n' "${container_name}" &&
	docker exec -it "${container_name}" sh -c 'cat /var/www/html/config/config.ini.php' &&
	[ "$(docker inspect -f '{{.State.Running}}' "${container_name}" 2>/dev/null)" = true ] && docker stop "${container_name}" -t1 >/dev/null
done

