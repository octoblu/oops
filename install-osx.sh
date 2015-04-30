#!/bin/bash

DIR="`dirname \"$0\"`" # relative
DIR="`( cd \"$MY_PATH\" && pwd )`" # absolute
echo ln -nsf $DIR/oops.sh /usr/local/bin/oops
ln -nsf $DIR/oops.sh /usr/local/bin/oops
