#!/bin/bash
set -e

ROOTFS="/mnt/rootfs"
echo "[INFO] Mounting pseudo filesystems (read-write) into $ROOTFS"

mount --rbind /proc "$ROOTFS/proc"
mount --make-rslave "$ROOTFS/proc"

mount --rbind /sys "$ROOTFS/sys"
mount --make-rslave "$ROOTFS/sys"

mount --rbind /dev "$ROOTFS/dev"
mount --make-rslave "$ROOTFS/dev"

mount --rbind /dev "$ROOTFS/run"
mount --make-rslave "$ROOTFS/run"

# Handle resolv.conf (replace symlink or file with custom nameserver)
if [ -L "$ROOTFS/etc/resolv.conf" ] || [ -f "$ROOTFS/etc/resolv.conf" ]; then
    rm -f "$ROOTFS/etc/resolv.conf"
fi
echo "nameserver 8.8.8.8" | tee "$ROOTFS/etc/resolv.conf" > /dev/null

echo "[INFO] All mounts completed in read-write mode."
