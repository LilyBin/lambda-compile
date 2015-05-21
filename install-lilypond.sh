#!/bin/sh
# $0 <version>

set -e

version=$1

if test -d ly; then exit; fi

curl -s -o lilypond.tar https://s3-us-west-2.amazonaws.com/lilypad-test/lilypond-$version-linux-64.tar
mkdir ly
tar -C ly -xf lilypond.tar

# Try to fix the fontmap bug
expandargs='"$@"'
cp ly/usr/bin/gs ly/usr/bin/gs.orig
cat <<EOF >ly/usr/bin/gs
#!/bin/sh
gs.orig -dNOFONTMAP $expandargs
EOF
