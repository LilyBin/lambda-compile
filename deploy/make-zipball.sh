#!/bin/sh

set -e

rm -f code.zip
# aws-sdk is already available in the container
zip --exclude node_modules/aws-sdk/\* -r code.zip index.js install-lilypond.sh version lib node_modules
