#!/bin/sh

PWD=`realpath $(dirname $0)`
if [ -d $PWD ]; then
  rsync -avz --exclude 'install.sh' --exclude '.git' --exclude 'README.md' $PWD/* ~/
fi
