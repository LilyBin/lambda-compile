#!/bin/sh

set -e

func='lilypad-test2'

rm code.zip
# aws-sdk is already available in the container
zip --exclude node_modules/aws-sdk/\* -r code.zip index.js lib lilypond-2.18.2-1.linux-64.sh node_modules/
aws lambda update-function-code --function-name "$func" --zip-file fileb://code.zip
