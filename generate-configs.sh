#!/usr/bin/env sh

set -eu

: "${matomo_version:?}"

systemctl is-active docker.service >/dev/null || ( printf 'Docker daemon is not running.\n' && exit 1)
docker buildx version >/dev/null 2>&1 || (printf 'Install "docker buildx" before continuing.\n' && exit 1)

inspect_json=$(docker buildx imagetools inspect "matomo:${matomo_version}" --format '{{json .}}' | jq -rc '.')
: "${inspect_json:?}"

matomo_version_digest=$(printf '%s' "${inspect_json}" | jq -r '.digest // .manifest.digest')
: "${matomo_version_digest:?}"

matomo_entrypoint=$(printf '%s' "${inspect_json}" | jq -rc '.image[]|.config.Entrypoint[]'| uniq)
: "${matomo_entrypoint:?}"

matomo_cmd=$(printf '%s' "${inspect_json}" | jq -rc '.image[]|.config.Cmd[]'| uniq)
: "${matomo_cmd:?}"

sed -i "s|^# matomo:.*|# matomo:${matomo_version}|g" Dockerfile
sed -i "s|^FROM .*|FROM docker.io/library/matomo@${matomo_version_digest}|g" Dockerfile
sed -i "s|^CMD .*|CMD [\"${matomo_cmd}\"]|g" Dockerfile
sed -i "s|^exec .*|exec ${matomo_entrypoint} \"\$\@\"|g" docker-entrypoint.sh

