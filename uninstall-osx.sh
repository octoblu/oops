#!/bin/bash

echo rm /usr/local/bin/oops
echo rm /usr/local/bin/oops-deploy
echo rm /usr/local/bin/oops-list
echo rm /usr/local/bin/oops-rollback
rm -f /usr/local/bin/oops
rm -f /usr/local/bin/oops-deploy
rm -f /usr/local/bin/oops-list
rm -f /usr/local/bin/oops-rollback

echo -e "\n oops removed"
