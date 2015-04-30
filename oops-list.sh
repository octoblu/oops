#!/bin/bash

APPLICATION_NAME=`jq --raw-output '."application-name"' .oopsrc`
DEPLOYMENT_GROUP=`jq --raw-output '."deployment-group"' .oopsrc`
DEPLOY_BUCKET=`jq --raw-output '."s3-bucket"' .oopsrc`
DEPLOY_KEY="${APPLICATION_NAME}/${APPLICATION_NAME}-${GIT_COMMIT}.zip"

echo -e "\nAvailable versions:\n"

aws s3 ls "s3://${DEPLOY_BUCKET}/${APPLICATION_NAME}/" --recursive |
  sort --reverse
