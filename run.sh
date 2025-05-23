docker run --rm -it --platform linux/arm64 \
  --privileged \
  -v /dev:/dev \
  -v $(pwd)/workspace:/root/workspace \
  -v $(pwd)/scripts:/root/scripts \
  -v $(pwd)/boot:/root/boot \
  -v $(pwd)/output:/root/output \
  -v $(pwd)/rootfs:/mnt/rootfs \
  ubuntu-auto:kria
