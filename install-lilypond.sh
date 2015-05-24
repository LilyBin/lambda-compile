#!/bin/sh

set -e

DIR=$(dirname `readlink -f "$0"`)
version="`cat $DIR/version`"

if test -d ly; then exit; fi

curl -s -o lilypond.tar https://s3-us-west-2.amazonaws.com/lilybin-tarballs/lilypond-$version-linux-64.tar
mkdir ly
tar -C ly -xf lilypond.tar

# Try to fix the fontmap bug
expandargs='"$@"'
cp ly/usr/bin/gs ly/usr/bin/gs.orig
cat <<EOF >ly/usr/bin/gs
#!/bin/sh
gs.orig -dNOFONTMAP $expandargs
EOF
