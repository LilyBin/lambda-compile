#!/bin/sh

set -e

version=$1
lilypad_version=$2

if ! [ -e ${version}.sh ]; then
  echo
  echo '>>> Downloading'
  echo ">>> curl -o ${version}.sh http://download.linuxaudio.org/lilypond/binaries/linux-64/lilypond-${version}.linux-64.sh"
  echo
  curl -o ${version}.sh http://download.linuxaudio.org/lilypond/binaries/linux-64/lilypond-${version}.linux-64.sh
fi

echo
echo '>>> Untarring'
echo ">>> sh ${version}.sh --tarball --batch"
echo
sh ${version}.sh --tarball --batch

echo
echo '>>> bunzipping'
echo ">>> bunzip2 lilypond-${version}.linux-64.tar.bz2"
echo
bunzip2 lilypond-${version}.linux-64.tar.bz2

if [ "$lilypad_version" ]; then
  echo
  echo '>>> renaming'
  echo ">>> mv lilypond-${version}.linux-64.tar lilypond-${lilypad_version}-linux-64.tar"
  echo
  mv lilypond-${version}.linux-64.tar lilypond-${lilypad_version}-linux-64.tar
fi
