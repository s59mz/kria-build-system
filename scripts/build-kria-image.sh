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
DEB_FILES_SCRIPT="/root/scripts/xil-deb-packages.sh"
DOCKER_SCRIPT="/root/scripts/install-docker.sh"
MODULES_SCRIPT="/root/scripts/install-modules.sh"
POST_SCRIPT="/root/scripts/post-config.sh"

# === STEP 1: DOWNLOAD UBUNTU ROOTFS IF NEEDED ===
if [ ! -f "/root/workspace/$ROOTFS_TAR" ]; then
    echo "[STEP 1] Downloading Ubuntu base rootfs..."
    wget -O "/root/workspace/$ROOTFS_TAR" "$ROOTFS_URL"
else
    echo "[STEP 1] Ubuntu base rootfs archive already exists."
fi

# === STEP 2: EXTRACT ROOTFS ===
if [ ! -d "$ROOTFS_DIR/root" ]; then
    echo "[STEP 2] Extracting rootfs to $ROOTFS_DIR..."
    tar -xpf "/root/workspace/$ROOTFS_TAR" -C "$ROOTFS_DIR"
else
    echo "[STEP 2] rootfs exists already..."
fi

# === STEP 3: INSTALL MODULES ===
if [ ! -d "$ROOTFS_DIR/lib/modules" ]; then
    echo "[STEP 3] Installing Kernel Modules ..."
    bash "$MODULES_SCRIPT"
else
    echo "[STEP 3] Kernel Modules installed already..."
fi

# === STEP 4: PREPARE CHROOT ENVIRONMENT ===
echo "[STEP 4] Mounting filesystems for chroot..."
bash "$MOUNT_SCRIPT"

# === STEP 5: INSTALL BASE PACKAGES ===
echo "[STEP 5] Installing base packages in chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y systemd udev ubuntu-standard iproute2 iputils-ping net-tools \
                   dnsutils less sudo tzdata kmod openssh-server \
                   locales ca-certificates bash-completion dbus \
                   software-properties-common
 
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    update-locale LANG=en_US.UTF-8
"

# === STEP 6: INSTALL ADDITIONAL PACKAGES ===
echo "[STEP 6] Installing additional packages in chroot..."
bash "$PACKAGES_SCRIPT"
bash "$DOCKER_SCRIPT"
bash "$DEB_FILES_SCRIPT"

# === STEP 7: POST CONFIGURATION ===
echo "[STEP 7] Post configuring..."
bash "$POST_SCRIPT"

# === STEP 8: CLEAN UP CHROOT ===
echo "[STEP 8] Unmounting chroot filesystems..."
bash "$UMOUNT_SCRIPT"

# === STEP 9: CREATE WIC IMAGE ===
echo "[STEP 9] Creating SD card image..."
bash "$WIC_SCRIPT"

echo "[DONE] SD card image is ready in /root/output/"
