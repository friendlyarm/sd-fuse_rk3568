#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3568/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3568/images
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b master sd-fuse_rk3568
cd sd-fuse_rk3568


wget ${CDN_URL}/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz

wget ${CDN_URL}/openmediavault-arm64-images.tgz
tar xzf openmediavault-arm64-images.tgz

wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

wget ${CDN_URL}/ubuntu-focal-desktop-arm64-images.tgz
tar xzf ubuntu-focal-desktop-arm64-images.tgz

wget ${CDN_URL}/debian-bullseye-desktop-arm64-images.tgz
tar xzf debian-bullseye-desktop-arm64-images.tgz


./mk-sd-image.sh ubuntu-focal-desktop-arm64
./mk-emmc-image.sh ubuntu-focal-desktop-arm64

./mk-sd-image.sh debian-bullseye-desktop-arm64
./mk-emmc-image.sh debian-bullseye-desktop-arm64

./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64

./mk-sd-image.sh openmediavault-arm64
./mk-emmc-image.sh openmediavault-arm64

./mk-emmc-image.sh friendlycore-focal-arm64 filename=friendlycore-lite-focal-auto-eflasher.img autostart=yes

wget ${CDN_URL}/friendlywrt25-images.tgz
tar xzf friendlywrt25-images.tgz

wget ${CDN_URL}/friendlywrt25-docker-images.tgz
tar xzf friendlywrt25-docker-images.tgz

./mk-sd-image.sh friendlywrt25
./mk-emmc-image.sh friendlywrt25 autostart=yes

./mk-sd-image.sh friendlywrt25-docker
./mk-emmc-image.sh friendlywrt25-docker autostart=yes

echo "done."
