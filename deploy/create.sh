#!/bin/sh

set -e

version=$1
echo "$version" > version
deploy/make-tarball.sh

aws lambda create-function --function-name "lilypad-$version" --runtime nodejs --role 'arn:aws:iam::557741380252:role/lilypad2' --handler 'index.handler' --timeout 30 --memory-size 1024 --zip-file fileb://code.zip
