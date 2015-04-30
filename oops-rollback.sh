#!/bin/bash


if [ "$1" == "--help" ] ||
   [ "$1" == "-h" ]; then
  echo -e "
  Usage: oops-rollback [options]


  Options:

    -h, --help    output usage information
    -c, --current list current color/port and exit \n\n"
  exit 1
fi


echo "Identifying active cluster..."
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

if [ "$1" == "--current" ] ||
   [ "$1" == "-c" ]; then

  echo "Active color: '${OLD_COLOR}', port: '${OLD_PORT}'"
  exit 1
fi

echo "Active cluster: '${OLD_COLOR}'. Rolling back..."

AWS_DEFAULT_REGION=us-west-2 aws elb delete-load-balancer-listeners --load-balancer-name ${ELB_NAME} --load-balancer-ports 80
AWS_DEFAULT_REGION=us-west-2 aws elb delete-load-balancer-listeners --load-balancer-name ${ELB_NAME} --load-balancer-ports 443
AWS_DEFAULT_REGION=us-west-2 aws elb create-load-balancer-listeners --load-balancer-name ${ELB_NAME} --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=${NEW_PORT}
AWS_DEFAULT_REGION=us-west-2 aws elb create-load-balancer-listeners --load-balancer-name ${ELB_NAME} --listeners Protocol=HTTPS,LoadBalancerPort=443,InstanceProtocol=HTTP,InstancePort=${NEW_PORT},SSLCertificateId=arn:aws:iam::822069890720:server-certificate/startinter.octoblu.com

AWS_DEFAULT_REGION=us-west-2 aws elb configure-health-check --load-balancer-name ${ELB_NAME} --health-check Target=HTTP:${NEW_PORT}/healthcheck,Interval=30,Timeout=5,UnhealthyThreshold=2,HealthyThreshold=2 > /dev/null

echo -e "\nRolled back, '${NEW_COLOR}' is now active"
