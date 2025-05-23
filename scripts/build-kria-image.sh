#!/bin/bash
set -e

# === CONFIGURATION ===
ROOTFS_DIR="/mnt/rootfs"
ROOTFS_TAR="ubuntu-base-22.04-base-arm64.tar.gz"
ROOTFS_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/$ROOTFS_TAR"
WIC_SCRIPT="/root/scripts/make_wic_image.sh"
MOUNT_SCRIPT="/root/scripts/mount-chroot-ro.sh"
UMOUNT_SCRIPT="/root/scripts/umount-chroot-ro.sh"
PACKAGES_SCRIPT="/root/scripts/additional-packages.sh"
POST_SCRIPT="/root/scripts/post-config.sh"

# === STEP 1: DOWNLOAD UBUNTU ROOTFS IF NEEDED ===
echo "[STEP 1] Checking Ubuntu rootfs..."
if [ ! -f "/root/workspace/$ROOTFS_TAR" ]; then
    echo "Downloading Ubuntu base rootfs..."
    wget -O "/root/workspace/$ROOTFS_TAR" "$ROOTFS_URL"
else
    echo "Ubuntu base rootfs archive already exists."
fi

# === STEP 2: EXTRACT ROOTFS ===
echo "[STEP 2] Extracting rootfs to $ROOTFS_DIR..."
rm -rf $ROOTFS_DIR/*
tar -xpf "/root/workspace/$ROOTFS_TAR" -C "$ROOTFS_DIR"

# === STEP 3: PREPARE CHROOT ENVIRONMENT ===
echo "[STEP 3] Mounting filesystems for chroot..."
bash "$MOUNT_SCRIPT"

# === STEP 4: INSTALL BASE PACKAGES ===
echo "[STEP 4] Installing base packages in chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y systemd udev ubuntu-standard iproute2 iputils-ping net-tools \
                   dnsutils less sudo tzdata kmod openssh-server \
                   locales ca-certificates bash-completion dbus
"

# === STEP 5: INSTALL ADDITIONAL PACKAGES ===
echo "[STEP 5] Installing additional packages in chroot..."
bash "$PACKAGES_SCRIPT"

# === STEP 6: POST CONFIGURATION ===
echo "[STEP 6] Post configuring..."
bash "$POST_SCRIPT"

# === STEP 7: CLEAN UP CHROOT ===
echo "[STEP 7] Unmounting chroot filesystems..."
bash "$UMOUNT_SCRIPT"

# === STEP 8: CREATE WIC IMAGE ===
echo "[STEP 8] Creating SD card image..."
bash "$WIC_SCRIPT"

echo "[DONE] SD card image is ready in /root/output/"
