#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3568
cd sd-fuse_rk3568

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))
# alway clone kernel from github
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi6-v6.1.y_rt16

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3568/images-for-eflasher/debian-bullseye-desktop-arm64-images.tgz
tar xvzf debian-bullseye-desktop-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3568/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

wget http://${HTTP_SERVER}/sd-fuse/kernel-3rd-drivers.tgz
if [ -f kernel-3rd-drivers.tgz ]; then
	pushd out
	tar xzf ../kernel-3rd-drivers.tgz
	popd
fi

git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3568
KCFG="nanopi5_linux_defconfig kvm.config lowlatency.config" \
	KERNEL_SRC=$PWD/kernel-rk3568 \
	./build-kernel.sh debian-bullseye-desktop-arm64

sudo ./mk-sd-image.sh debian-bullseye-desktop-arm64
sudo ./mk-emmc-image.sh debian-bullseye-desktop-arm64
