ARG PLATFORM=linux/arm64

# Use official Ubuntu ARM64 base image
FROM --platform=$PLATFORM ubuntu:22.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    locales \
    vim \
    bash-completion \
    net-tools \
    iproute2 \
    iputils-ping \
    less \
    tzdata \
    systemd \
    parted \
    udev \
    dosfstools \
    zip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Set working directory
WORKDIR /root

# Switch to user
USER root

# Copy helper scripts (e.g., fetch rootfs, mount, chroot, wic creation)
#COPY scripts/ ./scripts/
#RUN chmod +x ./scripts/*.sh

# Copy boot files (Image, DTB, boot.cmd)
#COPY boot/ ./boot/

# Entry point for automation: fetch rootfs, configure it, and generate .wic image
#CMD ["bash", "./scripts/build-kria-image.sh"]
CMD ["/bin/bash"]
