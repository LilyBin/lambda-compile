#!/bin/sh

for f in lilypond-*.tar; do
	aws --profile admin s3 cp --storage-class REDUCED_REDUNDANCY $f s3://lilypad-tarball/
done
[ -e version.json ] && aws --profile admin s3 cp --storage-class REDUCED_REDUNDANCY version.json s3://lilypad-tarball/
