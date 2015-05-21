#!/bin/sh

stable=`curl -s 'http://lilypond.org/unix.html' | \
	sed -n 's,.*http://download\.linuxaudio\.org/lilypond/binaries/linux-64/lilypond-\([0-9\.-]*\)\.linux-64\.sh".*,\1,p'`
unstable=`curl -s 'http://lilypond.org/development.html' | \
	sed -n 's,.*http://download\.linuxaudio\.org/lilypond/binaries/linux-64/lilypond-\([0-9\.-]*\)\.linux-64\.sh".*,\1,p'`

echo Stable: $stable
echo Unstable: $unstable
