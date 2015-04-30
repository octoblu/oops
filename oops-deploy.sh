#!/bin/bash


if [ "$1" == "" ] ||
   [ "$1" == "--help" ] ||
   [ "$1" == "-h" ]; then
  echo -e "
  Usage: oops-deploy [git-commit] [options]


  Options:

    -h, --help   output usage information\n\n"
  exit 1
fi

GIT_COMMIT=$1
echo "Deploying ${GIT_COMMIT}"
DEPLOY_REGION=us-west-2
APPLICATION_NAME=`jq --raw-output '."application-name"' .oopsrc`
DEPLOYMENT_GROUP=`jq --raw-output '."deployment-group"' .oopsrc`
DEPLOY_BUCKET=`jq --raw-output '."s3-bucket"' .oopsrc`
DEPLOY_KEY="${APPLICATION_NAME}/${APPLICATION_NAME}-${GIT_COMMIT}.zip"

aws deploy create-deployment --application-name ${APPLICATION_NAME} --region ${DEPLOY_REGION} --deployment-group ${DEPLOYMENT_GROUP} --revision "{\"revisionType\":\"S3\", \"s3Location\": {\"bucket\": \"${DEPLOY_BUCKET}\", \"key\": \"${DEPLOY_KEY}\", \"bundleType\": \"zip\"}}"
