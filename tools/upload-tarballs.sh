#!/bin/sh

for f in lilypond-*.tar; do
	aws s3 cp --storage-class REDUCED_REDUNDANCY $f s3://lilypad-tarball/
done
