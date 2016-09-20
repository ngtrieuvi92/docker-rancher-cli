#!/bin/bash

# All env variables of script
# RANCHER_ACCESS_KEY
# RANCHER_SECRET_KEY
# RANCHER_STACK_NAME
# RANCHER_REGISTRY_URL
# RANCHER_DOCKER_IMAGE_NAMESPACE
# RANCHER_DOCKER_IMAGE_NAME
# RANCHER_DOCKER_IMAGE_TAG

# Check and set default variables
RANCHER_REGISTRY_URL=${RANCHER_REGISTRY_URL:-"registry\.gitlab\.com"}
RANCHER_DOCKER_IMAGE_NAMESPACE=${RANCHER_DOCKER_IMAGE_NAMESPACE:-"gu_cms"}
RANCHER_DOCKER_IMAGE_NAME=${RANCHER_DOCKER_IMAGE_NAME:-"gu_cms"}
RANCHER_DOCKER_IMAGE_TAG=${CI_BUILD_REF:-"dev"}

RANCHER_STACK_NAME=${RANCHER_STACK_NAME:-'gu-cms'}

# Declare some util function# Do exit with error code 1 if any error occur
# Do exit if have error occur
function do_error_exit {
  echo "> Error: $1"
  exit 1;
}

# get stack config
function get_stack_config {
  echo "> Downloading stack $RANCHER_STACK_NAME from rancher server ..."
  rancher export -o stack.tar $RANCHER_STACK_NAME;
  OUT=$?
  if [ $OUT -ne 0 ]; then
    do_error_exit "Can not get stack"
  else
    tar -xvf stack.tar;
    OUT=$?
    if [ $OUT -ne 0 ]; then
      do_error_exit 'Can not extract stack'
    fi
  fi
}
get_stack_config

# update image in docker-compose.yml
sed -i "s/\($RANCHER_REGISTRY_URL\/$RANCHER_DOCKER_IMAGE_NAMESPACE\/$RANCHER_DOCKER_IMAGE_NAME\):\(.*\)/\1:$RANCHER_DOCKER_IMAGE_TAG/g" docker-compose.yml

# Verify docker image with new tag
# TODO

#
# deploy
function do_deploy {
  echo "rancher up  --upgrade --stack $RANCHER_STACK_NAME --pull --interval 30000 --batch-size 1 -d"
  rancher up  --upgrade --stack $RANCHER_STACK_NAME --pull --interval 30000 --batch-size 1 -d
# TODO hande update result and confirm or rollback update, bellow is cheating
  echo "# TODO hande update result and confirm or rollback update, bellow is cheating"
  echo "sleep 120"
  sleep 20
  echo "rancher up --upgrade --stack $RANCHER_STACK_NAME --confirm-upgrade -d"
  rancher up --upgrade --stack $RANCHER_STACK_NAME --confirm-upgrade -d
#   DEPLOY_RESULT=$(rancher wait $RANCHER_STACK_NAME)
#   if [[ $DEPLOY_RESULT == ?(-)+([0-9]) ]]; then
#     echo "> Deploy completed with exit code: $DEPLOY_RESULT"
#     exit $DEPLOY_RESULT
#   else
#     do_error_exit "Error: Cant not wait for deployment process completed: $DEPLOY_RESULT"
#   fi;
}
do_deploy

function do_migration_data {
  CONTAINER_NAME="$RANCHER_STACK_NAME\_$RANCHER_SERVICE_NAME\_1"
  rancher exec $CONTAINER_NAME doctrine-migrations migrations:migrate -n
}
do_migration_data
