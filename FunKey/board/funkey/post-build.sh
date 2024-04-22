#!/bin/sh

BOARD_COMMON_DIR="$(dirname $0)/../allwinner-generic/sun8i-t113"
BOARD_DIR="$(dirname $0)/../../output/images"

echo ------${BOARD_COMMON_DIR}
echo ++++++${BOARD_DIR}

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

# Redirect drobear keys to /tmp
rm -rf ${TARGET_DIR}/etc/dropbear
ln -s /tmp ${TARGET_DIR}/etc/dropbear

# Change dropbear init sequence
mv ${TARGET_DIR}/etc/init.d/S50dropbear ${TARGET_DIR}/etc/init.d/S42dropbear


cp $BOARD_COMMON_DIR/bin/ramdisk.img -rfvd  $BINARIES_DIR
cd $BINARIES_DIR
mkbootimg --kernel zImage  --ramdisk  ramdisk.img --board sun8iw20p1 --base  0x40200000 --kernel_offset  0x0 --ramdisk_offset  0x01000000 -o  boot.img
cp -f boot.img ../target/boot