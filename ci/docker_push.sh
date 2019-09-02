#!/usr/bin/env bash

set -eux

image_name="reitermarkus/cross:${TARGET}"

if [[ "${TAG-}" =~ ^v.* ]]; then
  version="${TAG##v}"
  versioned_image_name="${image_name}-${version}"
  docker tag "${image_name}" "${versioned_image_name}"
  docker push "${versioned_image_name}"
fi

docker push "${image_name}"
