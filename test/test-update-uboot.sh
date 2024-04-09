#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243
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
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3568/old/kernel-5.10.y/images-for-eflasher/friendlycore-focal-arm64-images.tgz
    tar xvzf friendlycore-focal-arm64-images.tgz
fi

git clone ${UBOOT_REPO} --depth 1 -b ${UBOOT_BRANCH} uboot-rk3568
[ -d rkbin ] || git clone https://github.com/friendlyarm/rkbin --depth 1 -b nanopi5
UBOOT_SRC=$PWD/uboot-rk3568 ./build-uboot.sh friendlycore-focal-arm64
sudo ./mk-sd-image.sh friendlycore-focal-arm64
