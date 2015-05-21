#!/bin/sh

func='lilypad-test2'

aws lambda invoke --invocation-type RequestResponse --function-name "$func" --region us-west-2 --log-type Tail --payload file://payload.json output.txt
