#!/bin/sh

set -e

if ! [ "$1" ]; then
  echo "You didn't specify which version to deploy"
  exit 1
fi

version=$1
root=deploy-$version
rm -rf $root
mkdir $root
tools/update.sh $version $root/ly
deploy/make-zipball.sh $version $root

echo
echo '>>> Uploading'
echo ">>> aws --profile admin lambda update-function-code --function-name "lilybin-$version" --zip-file fileb://deploy-$version.zip"
echo
aws --profile admin lambda update-function-code \
  --function-name "lilybin-$version" \
  --zip-file fileb://deploy-$version.zip
