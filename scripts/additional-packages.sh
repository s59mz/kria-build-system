#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"

echo "[INFO ] Installing Additional Packages..."

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update

    apt install -y tree \
                   vim \
                   git \
                   curl \
                   gnupg \
                   arptables \
                   ebtables \
                   fuse-overlayfs \
                   u-boot-tools \
                   uidmap \
                   libdrm-tests \
                   v4l-utils 
"
echo "[INFO ] Additional Packages Installed"
