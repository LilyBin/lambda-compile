#!/bin/sh

set -e

version=$1
root=$2

echo
echo '>>> Building JavaScript with Babel'
echo '>>> npm run build'
echo
npm run build

echo
echo '>>> Install production dependencies'
echo '>>> mkdir -p proddeps'
mkdir -p proddeps

echo '>>> cp package.json proddeps'
cp package.json proddeps

echo '>>> cd proddeps && npm i --production'
(cd proddeps && npm i --production)

echo

echo
echo '>>> Copy files to deployment directory'
echo
cp -a index.js lib proddeps/node_modules $root
mkdir $root/fonts
cp -a fonts/font-stylesheets $root/fonts

rm -f code.zip
echo
echo '>>> Zipping'
echo ">>> cd $root && zip -r ../deploy-$version.zip *"
echo
(cd $root && zip -9 -r ../deploy-$version.zip *)
