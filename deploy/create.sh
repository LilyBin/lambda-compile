#!/bin/sh

set -e

version=$1
echo "$version" > version
deploy/make-zipball.sh

aws --profile admin lambda create-function \
	--function-name "lilybin-$version"               \
	--runtime nodejs                                 \
	--role 'arn:aws:iam::557741380252:role/LilyBin'  \
	--handler 'index.handler'                        \
	--timeout 30 --memory-size 1024                  \
	--zip-file fileb://code.zip
