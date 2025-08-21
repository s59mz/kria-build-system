#!/bin/bash

USER_ADD="kria"
PASSWD_SET="kria"

echo "[INFO] Post configuring..."

# Set Root Password
echo "root:root" | chroot /mnt/rootfs chpasswd

# enable SSH for root
sed -i "s/^#PermitRootLogin.*/PermitRootLogin yes/" /mnt/rootfs/etc/ssh/sshd_config
chroot /mnt/rootfs systemctl enable ssh

# Create kria User and Grant Sudo Access
chroot /mnt/rootfs useradd -m -s /bin/bash $USER_ADD
echo "$USER_ADD:$PASSWD_SET" | chroot /mnt/rootfs chpasswd
chroot /mnt/rootfs usermod -aG sudo $USER_ADD

# set no sudo for KMS
#chroot /mnt/rootfs usermod -aG video $USER_ADD
#chroot /mnt/rootfs newgrp video

# Enable the user to properly use the Docker
chroot /mnt/rootfs groupadd docker
chroot /mnt/rootfs usermod -a -G docker $USER_ADD

# Set hosts
tee /mnt/rootfs/etc/hosts >/dev/null <<'EOF'
127.0.0.1   localhost localhost.localdomain
EOF

# Enable Networking Services
chroot /mnt/rootfs systemctl enable systemd-networkd
chroot /mnt/rootfs systemctl enable systemd-resolved

# Configure Ethernet Interface
tee /mnt/rootfs/etc/systemd/network/eth0.network >/dev/null <<'EOF'
[Match]
Name=eth0

[Network]
DHCP=yes
EOF

# set timezone
rm /mnt/rootfs/etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Ljubljana /mnt/rootfs/etc/localtime

echo "[INFO] Post configuration done."
