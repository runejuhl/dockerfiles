#!/bin/bash

set -euo pipefail

DOCKER_USER="${1}"
DOCKERFILE="${2}"

name=$(dirname "${DOCKERFILE}")
image_name="${DOCKER_USER}/${name}"

echo "called with ${DOCKER_USER} ${DOCKERFILE} ${image_name}" > /tmp/loolllo


docker inspect -f '{{ range $k, $v := .ContainerConfig.Labels -}}
LABEL {{ $k }}={{ $v }}
{{ end -}}' "${image_name}"
