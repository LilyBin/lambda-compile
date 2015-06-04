#!/bin/sh

set -e

if ! [ "$1" ]; then
  echo "You didn't specify which version to deploy"
  exit 1
fi

version=$1
tools/update.sh $version
deploy/make-zipball.sh

aws --profile admin lambda update-function-code \
  --function-name "lilybin-$version" \
  --zip-file fileb://code.zip
