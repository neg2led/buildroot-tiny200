#!/bin/bash
set -e
STARTDIR=`pwd`
SELFDIR=`dirname \`realpath ${0}\``
BOARDDIR='board/lctech/pi/f1c200s'
MKIMAGE="${HOST_DIR}/bin/mkimage"
IMAGE_ITS="kernel.its"
OUTPUT_NAME="kernel.itb"

[ $# -eq 2 ] || {
    echo "SYNTAX: $0 <output dir> <u-boot-with-spl image>"
    echo "Given: $@"
    exit 1
}

cp ${BOARDDIR}/scripts/${IMAGE_ITS} "${BINARIES_DIR}"
cd "${BINARIES_DIR}" && "${MKIMAGE}" -f ${IMAGE_ITS} ${OUTPUT_NAME} && rm ${IMAGE_ITS}

cd "${STARTDIR}/"
board/allwinner/generic/scripts/mknanduboot.sh ${1}/${2} ${1}/u-boot-sunxi-with-nand-spl.bin

[[ -f "${BINARIES_DIR}/rootfs.ext4" ]] && \
    support/scripts/genimage.sh ${1} -c ${BOARDDIR}/scripts/genimage-sdcard-ext4.cfg
[[ -f "${BINARIES_DIR}/rootfs.f2fs" ]] && \
    support/scripts/genimage.sh ${1} -c ${BOARDDIR}/scripts/genimage-sdcard-f2fs.cfg
[[ -f "${BINARIES_DIR}/rootfs.squashfs" ]] && \
    support/scripts/genimage.sh ${1} -c ${BOARDDIR}/scripts/genimage-nand-squashfs.cfg
[[ -f "${BINARIES_DIR}/rootfs.ubi" ]] && \
    support/scripts/genimage.sh ${1} -c ${BOARDDIR}/scripts/genimage-nand-ubifs.cfg
