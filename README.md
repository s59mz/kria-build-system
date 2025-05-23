
# Kria Build System

This project automates the creation of a custom Ubuntu-based SD card image for the AMD/Xilinx Kria KV260 board using Docker.
It leverages QEMU for ARM64 emulation, allowing you to build and configure the image entirely on an x86_64 host system.

## Features

- Automated Docker-based build environment for ARM64 Ubuntu images
- Customizable scripts for adding packages and post-install configurations
- Generation of `.wic` SD card images ready to boot on Kria boards
- Support for setting up users, SSH, networking, locale, and timezone
- Shared directories for easy script and file management between host and container

## Prerequisites

Ensure your host system meets the following requirements:

- **Operating System**: Ubuntu 22.04 LTS (or compatible)
- **Docker Engine**: Version 28.1.1 or newer
- **QEMU**: Version supporting ARM64 emulation

### Install Required Packages

Install Docker and QEMU:

```bash
sudo apt update
sudo apt install docker.io qemu-user-static
```

Add your user to the Docker group to run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Directory Structure

```plaintext
kria-build-system/
├── boot/
│   ├── boot.scr
│   ├── Image
│   └── system.dtb
├── build.sh
├── Dockerfile
├── LICENSE
├── output/
│   └── custom-linux-image.wic.zip
├── README.md
├── Readme.txt
├── rootfs/
├── run.sh
├── scripts/
│   ├── additional-packages.sh
│   ├── build-kria-image.sh
│   ├── make_wic_image.sh
│   ├── mount-chroot-ro.sh
│   ├── post-config.sh
│   └── umount-chroot-ro.sh
└── workspace/
    └── ubuntu-base-22.04-base-arm64.tar.gz
```

- `boot/`: Contains bootloader files (`boot.scr`, `Image`, `system.dtb`)
- `scripts/`: Shell scripts for building and configuring the image
- `workspace/`: Contains the base Ubuntu ARM64 root filesystem
- `output/`: Directory where the final `.wic` image is stored

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/s59mz/kria-build-system.git
cd kria-build-system
```

### 2. Build the Docker Image

```bash
./run.sh
```

### 3. Run the Docker Container

```bash
./run.sh
```

This command mounts necessary directories and shares the host's `/dev` to the container, which is required for loop device operations during image creation.

### 4. Build the SD Card Image

Inside the Docker container, execute:

```bash
./scripts/build-kria-image.sh
```

This script performs the following steps:

- Downloads and extracts the base Ubuntu ARM64 root filesystem
- Mounts the root filesystem and chroots into it
- Installs additional packages specified in `additional-packages.sh`
- Applies post-configuration settings from `post-config.sh`
- Creates a `.wic` SD card image and compresses it into a `.zip` file

The final image will be located at `output/custom-linux-image.wic.zip`.

## Customization

- To add additional packages, edit `scripts/additional-packages.sh`.
- For post-install configurations (e.g., setting up users, SSH, networking), modify `scripts/post-config.sh`.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

---

For more information and updates, visit the [Hackster.io project page](https://www.hackster.io/matjaz4/project-5-automate-kria-ubuntu-sd-card-image-with-docker-11f648).
