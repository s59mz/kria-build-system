#!/bin/bash
#set -e

ROOTFS=/mnt/rootfs

echo "[INFO] Unmounting pseudo filesystems from $ROOTFS"

umount -lf "$ROOTFS/proc" || true
umount -lf "$ROOTFS/sys" || true
umount -lf "$ROOTFS/dev/pts" || true
umount -lf "$ROOTFS/dev" || true
umount -lf "$ROOTFS/run" || true

# Restore resolv.conf to systemd-resolved symlink for Kria runtime
if [ ! -L "$ROOTFS/etc/resolv.conf" ]; then
    rm -f "$ROOTFS/etc/resolv.conf"
    ln -sf /run/systemd/resolve/resolv.conf "$ROOTFS/etc/resolv.conf"
    echo "[INFO] Restored /etc/resolv.conf symlink for systemd-resolved"
fi

echo "[INFO] All mounts safely unmounted."
