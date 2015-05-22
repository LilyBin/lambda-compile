#!/bin/sh

func='lilypad-unstable'

aws lambda invoke --profile lilypad --invocation-type RequestResponse --function-name "$func" --region us-west-2 --log-type Tail --payload file://payload.json output.txt
