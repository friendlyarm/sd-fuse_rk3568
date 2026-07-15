#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3568/images
    ROOTFS_URL=http://cdn.local/friendlyelec-cdn/rootfs/rk3568
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3568/images
    ROOTFS_URL=https://downloads.friendlyelec.com/rootfs/rk3568
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3568
cd sd-fuse_rk3568
wget ${CDN_URL}/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget ${ROOTFS_URL}/rootfs-friendlycore-focal-arm64.tgz
wget ${ROOTFS_URL}/rootfs-friendlycore-focal-arm64.tgz.sha256
sha256sum -c rootfs-friendlycore-focal-arm64.tgz.sha256

sudo tar xzfp rootfs-friendlycore-focal-arm64.tgz --numeric-owner --same-owner
sudo ./build-rootfs-img.sh friendlycore-focal-arm64/rootfs friendlycore-focal-arm64

./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64
