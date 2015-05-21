#!/bin/sh

set -e

func='lilypad-test2'

rm -f code.zip
# aws-sdk is already available in the container
zip --exclude node_modules/aws-sdk/\* -r code.zip index.js install-lilypond.sh lib node_modules/
aws lambda update-function-code --function-name "$func" --zip-file fileb://code.zip
