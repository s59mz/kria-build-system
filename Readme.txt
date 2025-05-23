###
##### Project-5: Automate Kria Ubuntu SD Card Image with Docker #####
###

# run this first to enable QEMU emulation for arm64
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes


# add a custom kernel image
cp /path/to/Image boot

# add a custom Kria DTS
cp /path/to/system.dtb boot

# add a custom Kria FPGA bit file
cp /path/to/system.bit boot


# run docker
./run.sh

# add additional packages
vi scripts/additional-packages.sh

# start the image building process
./scripts/build-kria-image.sh


# the created SD card image is provided in output dir
