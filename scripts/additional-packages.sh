#!/bib/bash

ROOTFS_DIR="/mnt/rootfs"

chroot "$ROOTFS_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y vim \
                   tree \
                   git 
"
