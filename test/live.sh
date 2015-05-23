#!/bin/sh

func='lilybin-unstable'

aws lambda invoke --profile lilybin --invocation-type RequestResponse --function-name "$func" --region us-west-2 --log-type Tail --payload file://payload.json output.txt
