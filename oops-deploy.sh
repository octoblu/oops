#!/bin/bash

GIT_COMMIT=$1
echo "Rolling back to ${GIT_COMMIT}"

DEPLOY_REGION=us-west-2
APPLICATION_NAME=`jq --raw-output '."application-name"' .oopsrc`
DEPLOYMENT_GROUP=`jq --raw-output '."deployment-group"' .oopsrc`
DEPLOY_BUCKET=`jq --raw-output '."s3-bucket"' .oopsrc`
DEPLOY_KEY="${APPLICATION_NAME}/${APPLICATION_NAME}-${GIT_COMMIT}.zip"

aws deploy create-deployment --application-name ${APPLICATION_NAME} --region ${DEPLOY_REGION} --deployment-group ${DEPLOYMENT_GROUP} --revision "{\"revisionType\":\"S3\", \"s3Location\": {\"bucket\": \"${DEPLOY_BUCKET}\", \"key\": \"${DEPLOY_KEY}\", \"bundleType\": \"zip\"}}"
