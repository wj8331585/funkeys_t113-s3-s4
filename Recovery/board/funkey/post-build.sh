#!/bin/sh
BOARD_COMMON_DIR="$(dirname $0)/../allwinner-generic/sun8i-t113"
BOARD_DIR="$(dirname $0)/../../output/images"

# Add local path to init scripts
sed -i '3iexport PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin' ${TARGET_DIR}/etc/init.d/rcK
sed -i '3iexport PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin' ${TARGET_DIR}/etc/init.d/rcS

# Remove log daemon init scripts since they are loaded from inittab
rm -f ${TARGET_DIR}/etc/init.d/S01syslogd ${TARGET_DIR}/etc/init.d/S02klogd

# Remove dhcp lib dir and link to /tmp
rm -rf ${TARGET_DIR}/var/lib/dhcp/
ln -s /tmp ${TARGET_DIR}/var/lib/dhcp

# Remove dhcpcd dir and link to /tmp
rm -rf ${TARGET_DIR}/var/db/dhcpcd/
ln -s /tmp ${TARGET_DIR}/var/db/dhcpcd

# Change dropbear init sequence
mv ${TARGET_DIR}/etc/init.d/S50dropbear ${TARGET_DIR}/etc/init.d/S42dropbear

# Redirect drobear keys to /tmp
rm -rf ${TARGET_DIR}/etc/dropbear
ln -s /tmp ${TARGET_DIR}/etc/dropbear

# Generate U-Boot environment for app
#${HOST_DIR}/bin/mkenvimage -p 0x0 -s 0x20000 -o ${BINARIES_DIR}/u-boot-env.img ${TARGET_DIR}/etc/u-boot.env

# Generate U-Boot environment for production
#cp ${TARGET_DIR}/etc/u-boot.env ${TARGET_DIR}/etc/u-boot-prod.env
#echo "assembly_tests=1" >> ${TARGET_DIR}/etc/u-boot-prod.env
#${HOST_DIR}/bin/mkenvimage -p 0x0 -s 0x20000 -o ${BINARIES_DIR}/u-boot-env-prod.img ${TARGET_DIR}/etc/u-boot-prod.env
#rm ${TARGET_DIR}/etc/u-boot-prod.env


# Copy Platfrom Files to BINARY_DIR
cp $BOARD_COMMON_DIR/bin/* -rfvd  $BINARIES_DIR

# Copy common file to BINARY_DIR
cp $BOARD_COMMON_DIR/../sunxi-generic/bin/* -rfvd  $BINARIES_DIR

# overlay bin file to BINARY_DIR
# cp $BOARD_DIR/bin/* -rfvd  $BINARIES_DIR

cd $BINARIES_DIR
echo "item=dtb, sun8i-mangopi-mq-dual-linux.dtb" >> boot_package.cfg

$BINARIES_DIR/dragonsecboot  -pack boot_package.cfg
$BINARIES_DIR/mkenvimage -r -p 0x00 -s 131072 -o env.fex env.cfg
mkbootimg --kernel zImage  --ramdisk  ramdisk.img --board sun8iw20p1 --base  0x40200000 --kernel_offset  0x0 --ramdisk_offset  0x01000000 -o  boot.img
mkdir -p ../target/boot
cp -f boot.img ../target/boot