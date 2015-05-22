#!/bin/sh

set -e

version=$1
echo "$version" > version
deploy/make-tarball.sh

aws lambda update-function-code --function-name "lilypad-$version" --zip-file fileb://code.zip
