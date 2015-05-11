#!/bin/bash


if [ "$1" == "--help" ] ||
   [ "$1" == "-h" ]; then
  echo -e "
  Usage: oops-status [options]


  Options:

    -h, --help    output usage information\n\n"
  exit 1
fi

ELB_NAME=`jq --raw-output '."elb-name"' .oopsrc`
BLUE_PORT=`aws elb describe-tags --load-balancer-name ${ELB_NAME} | jq '.TagDescriptions[0].Tags[] | select(.Key == "blue") | .Value | tonumber'`
GREEN_PORT=`aws elb describe-tags --load-balancer-name ${ELB_NAME} | jq '.TagDescriptions[0].Tags[] | select(.Key == "green") | .Value | tonumber'`

OLD_PORT=`AWS_DEFAULT_REGION=us-west-2 aws elb describe-load-balancers --load-balancer-name ${ELB_NAME} | jq '.LoadBalancerDescriptions[0].ListenerDescriptions[0].Listener.InstancePort'`

OLD_COLOR=green
NEW_COLOR=blue
NEW_PORT=${BLUE_PORT}
if [ "${OLD_PORT}" == "${BLUE_PORT}" ]; then
  OLD_COLOR=blue
  NEW_COLOR=green
  NEW_PORT=${GREEN_PORT}
fi

echo "{\"active\": {\"color\": \"${OLD_COLOR}\", \"port\": \"${OLD_PORT}\"}, \"off\": {\"color\": \"${NEW_COLOR}\", \"port\": \"${NEW_PORT}\"}}"
exit 0
