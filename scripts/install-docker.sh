#!/bin/bash

ROOTFS_DIR="/mnt/rootfs"

echo "[INFO ] Installing Docker Packages..."

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update
    install -m 0755 -d /etc/apt/keyrings
"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o $ROOTFS_DIR/etc/apt/keyrings/docker.asc
chmod a+r $ROOTFS_DIR/etc/apt/keyrings/docker.asc

echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" > \
    $ROOTFS_DIR/etc/apt/sources.list.d/docker.list

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
"
echo "[INFO ] Docker Packages Installed"
