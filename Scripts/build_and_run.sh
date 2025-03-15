#!/bin/bash

BUILD_DIR=../../build/raspberrypi
TARGET=mythos@192.168.0.128
DEST_DIR=/home/mythos/build

KERNEL=kernel8 make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs O=$BUILD_DIR -j$(nproc)
KERNEL=kernel8 make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=$BUILD_DIR/ INSTALL_MOD_PATH=$BUILD_DIR modules_install -j$(nproc)

rm $BUILD_DIR/lib/modules/6.6.78-v8+/build

echo "Start send file"
sshpass -p $1 scp $BUILD_DIR/arch/arm64/boot/Image $TARGET:$DEST_DIR/Image
sshpass -p $1 scp -r $BUILD_DIR/lib/modules/6.6.78-v8+/ $TARGET:$DEST_DIR/modules/

sshpass -p $1 scp $BUILD_DIR/arch/arm64/boot/dts/broadcom/*.dtb $TARGET:$DEST_DIR/dtb/
sshpass -p $1 scp $BUILD_DIR/arch/arm64/boot/dts/overlays/*.dtb* $TARGET:$DEST_DIR/dtb/overlays/

echo "move sending files"
sshpass -p $1 ssh -t $TARGET "echo $1 | sudo -S cp $DEST_DIR/Image /boot/firmware/kernel8.img"
sshpass -p $1 ssh -t $TARGET "echo $1 | sudo -S cp -r $DEST_DIR/dtb/ /boot/firmware/"
sshpass -p $1 ssh -t $TARGET "echo $1 | sudo -S cp -r $DEST_DIR/modules/ /lib/modules/6.6.74+rpt-rpi-v8/"

sshpass -p $1 ssh -t $TARGET "sync"

sshpass -p $1 ssh -t $TARGET "echo $1 | sudo -S reboot -h now"

echo "done!"
