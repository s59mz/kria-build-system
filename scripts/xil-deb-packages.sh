#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"

# install Xilinx Debian packages
echo "Installing Xilinx Debian files..."

cp -r /root/deb-pkgs /mnt/rootfs/tmp/

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive

    apt update

    add-apt-repository ppa:xilinx-apps --yes
    add-apt-repository ppa:ubuntu-xilinx/sdk --yes
    add-apt-repository ppa:xilinx-apps/xilinx-drivers --yes
    add-apt-repository ppa:lely/ppa --yes

    apt update
    apt upgrade --yes

    apt install -y \
                xrt \
                linux-firmware-xilinx-vcu \
                libxilinx-vcu0 \
                libxilinx-vcu-dev \
                xilinx-vcu-ctrl \
                xilinx-vcu-omx-utils \
                xlnx-default-bitstreams

    apt install -y /tmp/deb-pkgs/xlnx-platformstats_1.1_arm64.deb 
    apt install -y /tmp/deb-pkgs/libdfx1.0_2023.1-0ubuntu0xlnx2_arm64.deb
    apt install -y /tmp/deb-pkgs/libdfx-mgr1_2023.1+5918fb3-0ubuntu0xlnx2_arm64.deb
    apt install -y /tmp/deb-pkgs/dfx-mgr_2023.1+5918fb3-0ubuntu0xlnx2_arm64.deb
    apt install -y /tmp/deb-pkgs/xmutil_1.2ubuntu1_arm64.deb
    apt install -y /tmp/deb-pkgs/oem-limerick-kria-meta_0.17_all.deb
    apt install -y /tmp/deb-pkgs/fru-print_2022.1.6483e22-0ubuntu1~xlnx3_arm64.deb

    systemctl enable dfx-mgr.service
"
rm -r /mnt/rootfs/tmp/deb-pkgs

echo "Xilinx Debian Files Installed Successfully..."
