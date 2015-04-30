#!/bin/bash

echo "Verifying dependencies."
command -v aws &> /dev/null
if [ "$?" != 0 ]; then
  echo "Missing aws. I'm gonna need to ask for sudo on this one"
  echo "I'm about to run:"
  echo sudo sh -c "easy_install pip && pip install awscli"
  sudo sh -c "easy_install pip && pip install awscli"
fi

command -v jq &> /dev/null
if [ "$?" != 0 ]; then
  echo "Missing jq. I got this."
  brew install jq
  if [ "$?" != 0 ]; then
    echo 'Oh no! Something went horribly awry. You are on your own, I quit.'
    exit 1
  fi
fi

DIR="`dirname \"$0\"`" # relative
DIR="`( cd \"$MY_PATH\" && pwd )`" # absolute
echo ln -nsf $DIR/oops.sh /usr/local/bin/oops
echo ln -nsf $DIR/oops-deploy.sh /usr/local/bin/oops-deploy
echo ln -nsf $DIR/oops-list.sh /usr/local/bin/oops-list
echo ln -nsf $DIR/oops-rollback.sh /usr/local/bin/oops-rollback
ln -nsf $DIR/oops.sh /usr/local/bin/oops
ln -nsf $DIR/oops-deploy.sh /usr/local/bin/oops-deploy
ln -nsf $DIR/oops-list.sh /usr/local/bin/oops-list
ln -nsf $DIR/oops-rollback.sh /usr/local/bin/oops-rollback

echo -e "\n All done."
