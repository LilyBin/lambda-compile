#!/bin/sh

set -e

version=$1
output=$2

: ${output:=ly}

rm -rf $output
mkdir $output

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
echo '>>> Bunzipping'
echo ">>> tar -xjf lilypond-${version}.linux-64.tar.bz2 -C $output"
echo
tar -xjf lilypond-${version}.linux-64.tar.bz2 -C "$output"

rm -f ${version}.sh

# Try to fix the fontmap bug
echo
echo '>>> Patching Ghostscript'
echo
expandargs='"$@"'
cp $output/usr/bin/gs $output/usr/bin/gs.orig
cat <<EOF >$output/usr/bin/gs
#!/bin/sh
gs.orig -dNOFONTMAP $expandargs
EOF

# Copy fonts
echo
echo '>>> Copying fonts'
find fonts -iname '*.otf' -exec cp {} $output/usr/share/lilypond/current/fonts/otf/ \;
# We only ever produce PDF output, but in case we need SVG fonts at some point:
# find fonts -iname '*.woff' -o -iname '*.svg' -exec cp {} $output/usr/share/lilypond/current/fonts/svg/ \;

# See http://fonts.openlilylib.org/docs.html#patch-install
if expr "x$version" : "x2\\.18\\..*" >/dev/null; then
  echo '>>> Version 2.18.* needs font.scm patch'
  cp fonts/font.scm $output/usr/share/lilypond/current/scm/font.scm
fi
