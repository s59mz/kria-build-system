ARG PLATFORM=linux/arm64

# Use official Ubuntu ARM64 base image
FROM --platform=$PLATFORM ubuntu:22.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
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
    zip unzip \
    kmod \
    rsync \
    ca-certificates \
    git \
    build-essential \
    dkms \
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

# Entry point
CMD ["/bin/bash"]
