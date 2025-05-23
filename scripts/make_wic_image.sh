#!/bin/bash
set -e

# Configuration
BOOT_DIR=/root/boot
ROOTFS_DIR=/mnt/rootfs
IMAGE_NAME=output/custom-linux-image.wic
WORK_DIR=wic-tmp
BOOT_SIZE_MB=128
ROOTFS_SIZE_MB=4096

# Clean previous build
rm -rf "$WORK_DIR" "$IMAGE_NAME"
mkdir -p "$WORK_DIR"

echo "[1/6] Creating empty image file..."
IMAGE_SIZE_MB=$((BOOT_SIZE_MB + ROOTFS_SIZE_MB + 64))  # Extra padding
dd if=/dev/zero of=$IMAGE_NAME bs=1M count=$IMAGE_SIZE_MB

echo "[2/6] Partitioning image..."
parted --script $IMAGE_NAME \
    mklabel msdos \
    mkpart primary fat32 1MiB ${BOOT_SIZE_MB}MiB \
    mkpart primary ext4 ${BOOT_SIZE_MB}MiB 100% \
    set 1 boot on

LOOPDEV=$(losetup --show -f -P "$IMAGE_NAME")
echo "Using loop device: $LOOPDEV"

echo "[3/6] Creating filesystems..."
mkfs.vfat "${LOOPDEV}p1"
mkfs.ext4 "${LOOPDEV}p2"

echo "[4/6] Copying files to image..."

mkdir -p "$WORK_DIR/boot" "$WORK_DIR/rootfs"
mount "${LOOPDEV}p1" "$WORK_DIR/boot"
mount "${LOOPDEV}p2" "$WORK_DIR/rootfs"

cp -rv ${BOOT_DIR}/* "$WORK_DIR/boot/"
cp -a ${ROOTFS_DIR}/* "$WORK_DIR/rootfs/"

sync
umount "$WORK_DIR/boot"
umount "$WORK_DIR/rootfs"
losetup -d "$LOOPDEV"

# Clean build dir
rm -rf "$WORK_DIR"

echo "[5/6] Compressing image..."

zip ${IMAGE_NAME}.zip $IMAGE_NAME
rm $IMAGE_NAME

echo "[6/6] Image creation complete: $IMAGE_NAME"
