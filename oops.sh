#!/bin/bash

command -v aws &> /dev/null || { echo >&2 '"aws" cli tool is required. on OSX, "sudo easy_install pip && sudo pip install awscli"'; exit 1; }
command -v jq &> /dev/null || { echo >&2 '"jq" tool is required. on OSX, "brew install jq"'; exit 1; }

# aws elb describe-load-balancers

if [ ! -f .oopsrc ]; then
  echo "Missing .oopsrc, I don't know how to roll back :-("
  echo "Just make me a json file with the elb-name, that's all I need."
  echo -e "\nSample .oopsrc: "
  echo '
  {
    "elb-name": "www-octoblu-com",
    "application-name": "octoblu-www",
    "deployment-group": "master",
    "s3-bucket": "octoblu-deploy"
  }
  '
  exit 1
fi

# Validate .oopsrc
jq '.' .oopsrc &> /dev/null
if [ "$?" != "0" ]; then
  echo -e ".oopsrc is not valid JSON. Refusing to do anything else until you fix it.\n"

  jq '.' .oopsrc
  exit $?
fi

if [ "$1" == "deploy" ]; then
  oops-deploy ${*:2}
  exit $?
fi

if [ "$1" == "list" ]; then
  oops-list ${*:2}
  exit $?
fi

if [ "$1" == "off" ]; then
  oops-off ${*:2}
  exit $?
fi

if [ "$1" == "rollback" ]; then
  oops-rollback ${*:2}
  exit $?
fi

if [ "$1" == "status" ]; then
  oops-status ${*:2}
  exit $?
fi

echo -e "
  Usage: oops [command] [options]


  Commands:

    deploy       Deploy a specific version
    list         Show available versions to deploy to
    off          Map current off cluster to off.octoblu.com
    rollback     Swap ELB back to the off cluster
    status       Show colors and ports

  Options:

    -h, --help   output usage information\n\n"
