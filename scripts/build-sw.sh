#!/bin/bash
set -e
umask 022

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"

git init
git remote add origin "$GITHUB_SERVER_URL"/"$GITHUB_REPOSITORY"
git fetch origin "$GITHUB_REF"
git checkout FETCH_HEAD

cd src/sw
mkdir -vp "$SSTATE_DIR"
ln -vsnfT "$SSTATE_DIR" sstate_cache

. agilex5_dk_a5e065bb32aes1-rped-build.sh
build_setup
bitbake_image
package

cd agilex5_dk_a5e065bb32aes1-rped-images
mkdir -vp "$DESTDIR"
cp -vt "$DESTDIR" gsrd-console-image-agilex5.tar.gz kernel.itb sdimage.tar.gz u-boot-agilex5-socdk-rped-atf/u-boot-spl-dtb.hex
