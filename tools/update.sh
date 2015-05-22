#!/bin/sh

set -e

clean() {
  rm -f tmp-ver version.json *.tar
}

./check-new-version.sh >tmp-ver
stable=`grep '^stable' tmp-ver | cut -d' ' -f2`
unstable=`grep '^unstable' tmp-ver | cut -d' ' -f2`

./make-tarball.sh $stable stable
./make-tarball.sh $unstable unstable

./upload-tarballs.sh

clean
