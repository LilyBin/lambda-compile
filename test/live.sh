#!/bin/sh

if ! [ "$1" ]; then
  echo "You didn't specify which function to test"
  exit 1
fi

func="lilybin-$1"

aws lambda invoke --profile lilybin --invocation-type RequestResponse --function-name "$func" --region us-west-2 --log-type Tail --payload file://payload.json output.txt
