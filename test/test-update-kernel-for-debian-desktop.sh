#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi5-v5.10.y_opt

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3568
cd sd-fuse_rk3568
if [ -f ../../debian-bullseye-desktop-arm64-images.tgz ]; then
	tar xvzf ../../debian-bullseye-desktop-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3568/old/kernel-5.10.y/images-for-eflasher/debian-bullseye-desktop-arm64-images.tgz
    tar xvzf debian-bullseye-desktop-arm64-images.tgz
fi

if [ -f ../../kernel-rk3568.tgz ]; then
	tar xvzf ../../kernel-rk3568.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3568
fi

wget http://${HTTP_SERVER}/sd-fuse/kernel-3rd-drivers.tgz
if [ -f kernel-3rd-drivers.tgz ]; then
	pushd out
	tar xzf ../kernel-3rd-drivers.tgz
	popd
fi

KERNEL_SRC=$PWD/kernel-rk3568 ./build-kernel.sh debian-bullseye-desktop-arm64
sudo ./mk-sd-image.sh debian-bullseye-desktop-arm64
