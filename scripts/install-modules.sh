#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"
KERNEL_VER="5.15.0-1053-xilinx-zynqmp"

apt update

# get modules
if [ ! -f "/root/modules/linux-modules-${KERNEL_VER}_5.15.0-1053.57_arm64.deb" ]; then
    echo "Downloading Kernel Modules ..."
    apt-get download linux-modules-$KERNEL_VER

    mv linux-modules-${KERNEL_VER}_*.deb /root/modules
else
    echo "Found Kernel Modules"
fi

# copy modules to /lib/modules
dpkg-deb -x /root/modules/linux-modules-${KERNEL_VER}_*.deb /tmp/mods


echo "Installing Kernel Modules ..."
mkdir -p $ROOTFS_DIR/lib/modules/5.15.0-1053-xilinx-zynqmp/
rsync -a /tmp/mods/lib/modules/5.15.0-1053-xilinx-zynqmp/ $ROOTFS_DIR/lib/modules/5.15.0-1053-xilinx-zynqmp/

# Generate module dependency files for that kernel version
depmod -a -b $ROOTFS_DIR $KERNEL_VER

# remove the old zocl module v2.13
mv $ROOTFS_DIR/lib/modules/$KERNEL_VER/kernel/drivers/gpu/drm/zocl/zocl.ko \
   $ROOTFS_DIR/lib/modules/$KERNEL_VER/kernel/drivers/gpu/drm/zocl/zocl.ko.distro

# and replace it with a new precompiled zocl v2.15 for Vitis AI 3.5
if [ -f "/root/modules/zocl-2.15.zip" ]; then
    unzip /root/modules/zocl-2.15.zip -d $ROOTFS_DIR/lib/modules/$KERNEL_VER/kernel/drivers/gpu/drm/zocl/
else
    echo "Downloading Kernel Headers ..."
    apt install -y linux-headers-$KERNEL_VER

    # Get XRT sources at the 2023.1 tag (2.15)
    git clone --branch 202310.2.15.225 --depth 1 https://github.com/Xilinx/XRT.git
    cd /root/XRT/src/runtime_src/core/edge/drm/zocl

    make -C /lib/modules/$KERNEL_VER/build M="$PWD" clean

    # create header for undefined macros

    cat > zocl_local_version.h <<'EOF'
    #define XRT_BRANCH "2023.1"
    #define XRT_MODIFIED_FILES "0"
    #define XRT_HASH "manual"
    #define XRT_DATE "2023-04-17 "
EOF

    # Build the new module
    make -C /lib/modules/$KERNEL_VER/build M="$PWD" \
        EXTRA_CFLAGS="-include $PWD/zocl_local_version.h" \
        modules

    # Install the module
    cp zocl.ko $ROOTFS_DIR/lib/modules/$KERNEL_VER/kernel/drivers/gpu/drm/zocl/
fi

# Generate module dependency files for that kernel version
depmod -a -b $ROOTFS_DIR $KERNEL_VER

echo "Kernel Modules Installed Successfully"

