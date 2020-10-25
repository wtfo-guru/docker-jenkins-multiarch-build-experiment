
#!/bin/sh

if [ -n "$1" ]; then
  BUILD_ID="$1"
fi

if [ -n "${DOCKER_USE_REGISTRY+1}" ]; then
  echo "DOCKER_USE_REGISTRY is defined"
else
  echo "DOCKER_USE_REGISTRY is not defined"
  exit 1
fi

if [ -z "$BUILD_ID" ]; then
  BUILD_ID=`date '+%Y%m%d'`
fi

export DOCKER_CLI_EXPERIMENTAL=enabled

docker buildx version
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d

ls -al /proc/sys/fs/binfmt_misc/

docker buildx create --use --name multiarch
docker buildx ls

docker buildx build \
  -t ${DOCKER_USE_REGISTRY}/wtf/hello-arch:${BUILD_ID} \
  -t ${DOCKER_USE_REGISTRY}/wtf/hello-arch:latest \
  --platform=linux/arm,linux/arm64,linux/amd64 . --push

docker buildx rm
