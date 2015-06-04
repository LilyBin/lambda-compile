#!/bin/sh

set -e

if ! [ "$1" ]; then
  echo "You didn't specify which version to deploy"
  exit 1
fi

version=$1
tools/update.sh $version
deploy/make-zipball.sh

aws --profile admin lambda create-function \
  --function-name "lilybin-$version"               \
  --runtime nodejs                                 \
  --role 'arn:aws:iam::694582862809:role/lambda'  \
  --handler 'index.handler'                        \
  --timeout 30 --memory-size 1024                  \
  --zip-file fileb://code.zip
