#!/bin/bash
set -e 

AOSP_ROOT="/android/eos-a16"
CLANG_BIN="${AOSP_ROOT}/prebuilts/clang/host/linux-x86/clang-r433403b/bin"
GCC_BIN="${AOSP_ROOT}/prebuilts/gcc/linux-x86/aarch64/aarch64-none-linux-gnu/bin"

export PATH="${CLANG_BIN}:${GCC_BIN}:${PATH}"
export LD_LIBRARY_PATH="${AOSP_ROOT}/prebuilts/clang/host/linux-x86/clang-r433403b/lib64:${LD_LIBRARY_PATH}"

export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CLANG_TRIPLE=aarch64-linux-gnu-

export LLVM=1
export LLVM_IAS=1
export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export READELF=llvm-readelf
export OBJSIZE=llvm-size
export STRIP=llvm-strip

OUT_DIR="$(pwd)/../out"
DEFCONFIG="agate_defconfig" 

echo "Cleaning out directory..."
make O="${OUT_DIR}" clean
make O="${OUT_DIR}" mrproper

echo "Generating defconfig (${DEFCONFIG})..."
make O="${OUT_DIR}" ${DEFCONFIG}

echo "Compiling Kernel..."
make -j$(nproc --all) O="${OUT_DIR}" \
    ARCH=arm64 \
    CC="clang" \
    CROSS_COMPILE="${CROSS_COMPILE}" \
    CLANG_TRIPLE="${CLANG_TRIPLE}" \


echo "Build Complete!"