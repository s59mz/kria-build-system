#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update

    add-apt-repository ppa:xilinx-apps --yes
    add-apt-repository ppa:ubuntu-xilinx/sdk --yes 
    add-apt-repository ppa:xilinx-apps/xilinx-drivers --yes
    add-apt-repository ppa:lely/ppa --yes 
    apt update --yes 

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
                   xrt \
                   linux-firmware-xilinx-vcu
                   libxilinx-vcu0 \
                   libxilinx-vcu-dev \
                   xilinx-vcu-ctrl \
                   xilinx-vcu-omx-utils \
                   xlnx-default-bitstreams 

    apt upgrade --yes
"
echo "Additional Packages Installed Successfully..."
