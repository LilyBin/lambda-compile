#!/bin/sh

set -e

version=$1
output=$2

clean() {
  rm -f tmp-ver version.json
}

tools/check-new-version.sh >tmp-ver
ver=`grep "^$version" tmp-ver | cut -d' ' -f2`

tools/untar.sh $ver $output

clean
