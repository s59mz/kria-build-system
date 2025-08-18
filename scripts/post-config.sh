#!/bin/bash

# Set Root Password
echo "root:root" | chroot /mnt/rootfs chpasswd

# enable SSH for root
sed -i "s/^#PermitRootLogin.*/PermitRootLogin yes/" /mnt/rootfs/etc/ssh/sshd_config
chroot /mnt/rootfs systemctl enable ssh

# Create kria User and Grant Sudo Access
chroot /mnt/rootfs useradd -m -s /bin/bash kria
echo "kria:kria" | chroot /mnt/rootfs chpasswd
chroot /mnt/rootfs usermod -aG sudo kria

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
