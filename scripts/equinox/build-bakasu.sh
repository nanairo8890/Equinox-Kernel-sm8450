#!/usr/bin/env bash
# Equinox Kernel by LF52406 - BakaSU edition by Nanairo (with the author's permission).
#
# Builds the kernel Image with BakaSU (formerly ReSukiSU, the KernelSU/ submodule),
# SUSFS v2.3.0, BBR by default and Equinox's DroidSpaces KMI-safe profile.
# KernelSU-Next's production flow (build-production.sh) is not used by this edition.
#
#   CLANG_DIR=/path/to/clang/bin scripts/equinox/build-bakasu.sh [out dir]
#
# Any recent Clang works; release builds use AOSP clang-r584948. LTO=full selects
# full LTO like official Equinox (needs well over 10 GB of RAM); ThinLTO is the default.
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
OUT=$(realpath -m "${1:-$ROOT/out}")
[ -n "${CLANG_DIR:-}" ] && export PATH="$CLANG_DIR:$PATH"
export KBUILD_BUILD_USER="${KBUILD_BUILD_USER:-Nanairo}" KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST:-Equinox}"
MAKE=(make -C "$ROOT" O="$OUT" ARCH=arm64 LLVM=1 LLVM_IAS=1 LOCALVERSION= PYTHON=python3)

for cmd in clang ld.lld make python3 cpio git; do
    command -v "$cmd" >/dev/null || { echo "[!] missing tool: $cmd"; exit 1; }
done

# BakaSU refuses to build unless it is a git checkout (submodule)
[ -f "$ROOT/KernelSU/kernel/Kbuild" ] || git -C "$ROOT" submodule update --init KernelSU
[ "$(readlink "$ROOT/drivers/kernelsu")" = ../KernelSU/kernel ] || { echo '[!] drivers/kernelsu link missing'; exit 1; }

rm -rf "$OUT"
mkdir -p "$OUT"
"${MAKE[@]}" -s gki_defconfig
(cd "$ROOT" && scripts/kconfig/merge_config.sh -m -O "$OUT" "$OUT/.config" \
    arch/arm64/configs/vendor/waipio_GKI.config \
    arch/arm64/configs/vendor/xiaomi_GKI.config \
    arch/arm64/configs/vendor/mondrian_GKI.config \
    arch/arm64/configs/vendor/debugfs.config \
    scripts/equinox/configs/gatito-rootstack.config \
    scripts/equinox/configs/droidspaces-kmi-safe.config)
if [ "${LTO:-thin}" != full ]; then
    "$ROOT/scripts/config" --file "$OUT/.config" --disable LTO_CLANG_FULL --enable LTO_CLANG_THIN
fi
"${MAKE[@]}" -s olddefconfig

for opt in KSU KSU_SUSFS SYSVIPC CFI_CLANG MODVERSIONS DEFAULT_BBR; do
    grep -q "^CONFIG_$opt=y" "$OUT/.config" || { echo "[!] CONFIG_$opt is not enabled"; exit 1; }
done

rm -f "$OUT/include/config/auto.conf" "$OUT/include/config/auto.conf.cmd"
"${MAKE[@]}" -s olddefconfig
"${MAKE[@]}" -s prepare
release=$("${MAKE[@]}" -s kernelrelease)
[ "$release" = 5.10.269-Equinox ] || { echo "[!] unexpected kernel release: $release"; exit 1; }

"${MAKE[@]}" -j"$(nproc)" Image
echo "[+] $OUT/arch/arm64/boot/Image ($release)"
echo "    Before sharing a build, compare $OUT/vmlinux.symvers against a clean Equinox"
echo "    build with scripts/equinox/symvers-diff.sh: changed_crc and removed must be 0."
