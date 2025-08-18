#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"

# get modules
if [ ! -f "/root/modules/linux-modules-5.15.0-1053-xilinx-zynqmp_5.15.0-1053.57_arm64.deb" ]; then
    echo "Downloading Kernel Modules ..."
    apt update
    apt-get download linux-modules-5.15.0-1053-xilinx-zynqmp
    mv linux-modules-5.15.0-1053-xilinx-zynqmp_*.deb /root/modules
else
    echo "Found Kernel Modules"
fi

# copy modules to /lib/modules
dpkg-deb -x /root/modules/linux-modules-5.15.0-1053-xilinx-zynqmp_*.deb /tmp/mods


echo "Installing Kernel Modules ..."
mkdir -p $ROOTFS_DIR/lib/modules/5.15.0-1053-xilinx-zynqmp/
rsync -a /tmp/mods/lib/modules/5.15.0-1053-xilinx-zynqmp/ $ROOTFS_DIR/lib/modules/5.15.0-1053-xilinx-zynqmp/

# Generate module dependency files for that kernel version
depmod -a -b $ROOTFS_DIR 5.15.0-1053-xilinx-zynqmp

echo "Kernel Modules Installed Successfully"
