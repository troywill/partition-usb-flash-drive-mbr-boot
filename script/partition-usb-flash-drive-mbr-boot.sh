#!/bin/bash

set -o nounset

DEVICE="/dev/sdb"
BOOT_PARTITION="${DEVICE}1"
ROOT_PARTITION="${DEVICE}2"
LABEL="PNY16GB"

wipefs --all ${DEVICE}

# Create a BIOS/MBR partition table with parted
parted --script ${DEVICE} mklabel msdos

# Create an fat32 boot partition with parted
PART_TYPE="primary"
FS_TYPE="fat32"
START="1MiB"
END="513MiB"

parted --script ${DEVICE} mkpart $PART_TYPE $FS_TYPE $START $END
parted --script ${DEVICE} set 1 boot on

# Create a root partition with parted
START="513MiB"
PART_TYPE="primary"
FS_TYPE="ext4"
END="100%"
parted --script ${DEVICE} mkpart ${PART_TYPE} ${FS_TYPE} ${START} ${END}

# Format the root partition
mkfs.ext4 -v -L ${LABEL} ${ROOT_PARTITION}
