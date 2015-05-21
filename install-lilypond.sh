#!/bin/sh
set -e

curl -o lilypond.tar https://s3-us-west-2.amazonaws.com/lilypad-test/lilypond-stable-linux-64.tar
mkdir ly
tar -C ly -xf lilypond.tar

# Try to fix the fontmap bug
expandargs='"$@"'
cp ly/usr/bin/gs ly/usr/bin/gs.orig
cat <<EOF >ly/usr/bin/gs
#!/bin/sh
echo "This is a wrapper"
gs.orig -dNOFONTMAP $expandargs
EOF
