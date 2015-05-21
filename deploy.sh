#!/bin/sh

# aws-sdk is already available in the container
zip --exclude node_modules/aws-sdk/\* -r output.zip index.js lib lilypond-2.18.2-1.linux-64.sh node_modules/
