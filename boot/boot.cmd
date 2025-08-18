

#
# mkimage -A arm64 -T script -C none -n "Kria boot" -d boot.cmd boot.scr
#

echo "Loading kernel image.fit..."
load usb 0:1 0x10000000 image.fit

echo "Setting bootargs..."
#setenv bootargs 'console=ttyPS1,115200 root=/dev/sda2 rw rootwait earlycon ip=dhcp'

setenv bootargs console=ttyPS1,115200 root=/dev/nfs rw rootwait nfsroot=192.168.1.100:/Kria-images/kria-build-system/rootfs,v3 ip=dhcp cma=900M init=/sbin/init

echo "Booting..."
bootm 0x10000000#conf-smk-k26-revA-sck-kr-g-revB 0x10000000#conf-smk-k26-revA-sck-kr-g-revB 0x10000000#conf-smk-k26-revA-sck-kr-g-revB
