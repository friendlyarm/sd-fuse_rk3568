#!/bin/bash
set -eux

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3568/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3568/images
fi
UBOOT_REPO=https://github.com/friendlyarm/uboot-rockchip
UBOOT_BRANCH=nanopi5-v2017.09

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3568
cd sd-fuse_rk3568
if [ -f ../../friendlycore-focal-arm64-images.tgz ]; then
	tar xvzf ../../friendlycore-focal-arm64-images.tgz
else
	wget ${CDN_URL}/friendlycore-focal-arm64-images.tgz
    tar xvzf friendlycore-focal-arm64-images.tgz
fi

git clone ${UBOOT_REPO} --depth 1 -b ${UBOOT_BRANCH} uboot-rk3568
[ -d rkbin ] || git clone https://github.com/friendlyarm/rkbin --depth 1 -b nanopi5
UBOOT_SRC=$PWD/uboot-rk3568 ./build-uboot.sh friendlycore-focal-arm64
sudo ./mk-sd-image.sh friendlycore-focal-arm64
