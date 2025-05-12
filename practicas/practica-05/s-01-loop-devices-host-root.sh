#!/bin/bash

mkdir /unam/bda/disk-images

cd /unam/bda/disk-images

dd if=/dev/zero of=disk1.img bs=100M count=10

dd if=/dev/zero of=disk2.img bs=100M count=10

dd if=/dev/zero of=disk3.img bs=100M count=10

du -sh disk*.img

losetup -fP disk1.img

losetup -fP disk2.img

losetup -fP disk3.img

losetup -a

mkfs.ext4 disk1.img

mkfs.ext4 disk2.img

mkfs.ext4 disk3.img

mkdir -p /unam/bda/disks/d01

mkdir -p /unam/bda/disks/d02

mkdir -p /unam/bda/disks/d03


