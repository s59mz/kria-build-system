#!/bin/bash

# Set Root Password
echo "root:root" | chroot /mnt/rootfs chpasswd

# enable SSH for root
sed -i "s/^#PermitRootLogin.*/PermitRootLogin yes/" /mnt/rootfs/etc/ssh/sshd_config
chroot /mnt/rootfs systemctl systemctl enable ssh

# Create kria User and Grant Sudo Access
chroot /mnt/rootfs useradd -m -s /bin/bash kria
echo "kria:kria" | chroot /mnt/rootfs chpasswd
chroot /mnt/rootfs usermod -aG sudo kria

# Fix DNS Resolution
ln -sf /run/systemd/resolve/resolv.conf /mnt/rootfs/etc/resolv.conf

# Enable Networking Services
chroot /mnt/rootfs systemctl enable systemd-networkd
chroot /mnt/rootfs systemctl enable systemd-resolved

# Configure Ethernet Interface
cat > /mnt/rootfs/etc/systemd/network/eth0.network <<EOF
[Match]
Name=eth0

[Network]
DHCP=yes
EOF

# Preconfigure Locale
echo "en_US.UTF-8 UTF-8" >> /mnt/rootfs/etc/locale.gen
chroot /mnt/rootfs locale-gen
chroot /mnt/rootfs update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# set timezone
ln -sf /usr/share/zoneinfo/Europe/Ljubljana /mnt/rootfs/etc/localtime

