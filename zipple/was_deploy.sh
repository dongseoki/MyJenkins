#!/bin/bash
SERVICE_NAME=zipple-was
REPO_PATH=/home/ec2-user/git_repo/zipzoong-was
DOCKER_COMPOSE_PATH=/home/ec2-user/app
DOCKER_CONTAINER_NAME=was

echo "> ${SERVICE_NAME} deploy start"
start_time=$(date +%s)

echo "> step1: git pull"
cd ${REPO_PATH}
git fetch
git pull




echo 'build images'
docker build . -t ${SERVICE_NAME}:latest

echo 'remove old images'
# pass
cd ${DOCKER_COMPOSE_PATH}

echo 'stop ${SERVICE_NAME}'
docker stop ${DOCKER_CONTAINER_NAME}
sleep 8

echo 'start ${SERVICE_NAME} (docker compose up -d)'
docker compose up -d

echo ">  ${SERVICE_NAME} dev deploy end"
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

echo 'remove none images'
# <none>으로 태그된 이미지 ID를 가져옵니다.
images_to_remove=$(docker images | grep '<none>' | awk '{print $3}')

# 이미지 ID가 있는지 확인합니다.
if [ -z "$images_to_remove" ]; then
  echo "삭제할 이미지가 없습니다."
  exit 0
fi

# 각 이미지 ID에 대해 삭제 명령을 실행합니다.
for image_id in $images_to_remove; do
  echo "이미지 삭제 중: $image_id"
  docker rmi $image_id
done

echo "모든 <none> 이미지가 삭제되었습니다."

echo ">  ${SERVICE_NAME} Deployment took $elapsed_time seconds."
