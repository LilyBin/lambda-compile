#!/bin/sh

set -e

version=$1

rm -rf ly
mkdir ly

if ! [ -e "lilypond-${version}.linux-64.tar.bz2" ]; then
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
fi

echo
echo '>>> bunzipping'
echo ">>> tar -xjf lilypond-${version}.linux-64.tar.bz2 -C ly"
echo
tar -xjf lilypond-${version}.linux-64.tar.bz2 -C ly

rm -f ${version}.sh

# Try to fix the fontmap bug
expandargs='"$@"'
cp ly/usr/bin/gs ly/usr/bin/gs.orig
cat <<EOF >ly/usr/bin/gs
#!/bin/sh
gs.orig -dNOFONTMAP $expandargs
EOF
