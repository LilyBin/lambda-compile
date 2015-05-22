#!/bin/sh

stable=`curl -s 'http://lilypond.org/unix.html' | \
	sed -n 's,.*http://download\.linuxaudio\.org/lilypond/binaries/linux-64/lilypond-\([0-9\.-]*\)\.linux-64\.sh".*,\1,p'`
unstable=`curl -s 'http://lilypond.org/development.html' | \
	sed -n 's,.*http://download\.linuxaudio\.org/lilypond/binaries/linux-64/lilypond-\([0-9\.-]*\)\.linux-64\.sh".*,\1,p'`

stable_src=`echo $stable | cut -d'-' -f1`
unstable_src=`echo $unstable | cut -d'-' -f1`

cat <<EOF >version.json
{
  "stable": "$stable_src"
, "unstable": "$unstable_src"
}
EOF

echo stable $stable
echo unstable $unstable
