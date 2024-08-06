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
docker build . -t zipple-was:latest

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
echo ">  ${SERVICE_NAME} Deployment took $elapsed_time seconds."