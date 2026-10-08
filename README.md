<div align="center">

<img src="equinox-banner.png" alt="Equinox Kernel" width="100%">

# Equinox Kernel

**POCO F5 Pro / Redmi K60** · `mondrian` · Snapdragon 8+ Gen 1

**Developer:** [LF52406](https://github.com/LF52406) · **[Download builds](../../releases)**

</div>

---

> [!NOTE]
> **This fork is the BakaSU edition of Equinox**, made by **Nanairo** with LF52406's permission.
> It is Equinox 5.10.269 as released, with four changes:
>
> - **[BakaSU](https://github.com/Baka-SU/BakaSU)** (formerly ReSukiSU) instead of KernelSU-Next, as the `KernelSU/` submodule. Use the BakaSU manager 35217 or newer: this kernel uses UAPI 5, and older ReSukiSU managers (UAPI 4) ask to be updated before modules and `su` start.
> - **SUSFS v2.3.0** from [simonpunk's](https://gitlab.com/simonpunk/susfs4ksu) `gki-android12-5.10` branch, through BakaSU's built-in SUSFS support.
> - **BBR** as the default TCP congestion control.
> - **[NoMount](https://github.com/maxsteeel/nomount) v2.1.0** by maxsteeel built in (`fs/nomount`), with
>   deref3046's fix `7e7342c`. Use it with the official NoMount metamodule. Processes that BakaSU/SUSFS
>   umount modules for see the stock filesystem, and NoMount is hidden from `/sys/module` and `/proc/kallsyms`.
>
> Everything else, DroidSpaces included, is LF52406's work, described below. The official Equinox
> builds are at [LF52406/Equinox-Kernel-sm8450](https://github.com/LF52406/Equinox-Kernel-sm8450).
> Report problems with the BakaSU edition here, not to LF52406.
>
> Build: `CLANG_DIR=/path/to/clang/bin scripts/equinox/build-bakasu.sh` · Changes: [release notes](scripts/equinox/release-notes/5.10.269-bakasu-r2.md)

---

## Current Build

| Component | Current |
|:--|:--|
| **Linux** | `5.10.269-Equinox` |
| **Compatibility** | Android 16–17 · AOSP-based ROMs |
| **BakaSU** | `v4.2.0-rc3-c9246641` (35217) |
| **SUSFS** | `2.3.0` |
| **NoMount** | `v2.1.0` built in (+ `7e7342c`) |
| **DroidSpaces** | Supported |
| **TCP** | BBR default · CUBIC available |
| **Toolchain** | AOSP Clang `22.0.0` (r584948) |
| **Build** | ThinLTO · Clang CFI · MODVERSIONS |
| **KMI** | Verified against clean Equinox 5.10.269 |

---

## Features

| Group | Included |
|:--|:--|
| **Root & hiding** | KernelSU-Next integration · SUSFS |
| **Containers** | DroidSpaces · PID namespaces · IPC / SYSVIPC |
| **Networking** | TCP BBR · runtime congestion-control switching |
| **Device** | mondrian production config · Goodix touch stability fixes |
| **Packaging** | Verified AnyKernel3 release package |

---

## Latest Changes

### Linux 5.10.269

- Updated KernelSU-Next to `3.4.0`
- Integrated SUSFS `2.3.0`
- Added DroidSpaces support
- Added and verified TCP BBR support
- Added production KMI validation
- Added verified AnyKernel3 packaging

[View full release notes](../../releases)

---

## Downloads & Flashing

Official Equinox builds are published through **GitHub Releases**.

**Current package:** `Equinox-5.10.269-mondrian.zip`  
**SHA256:** `f05af44bd3ea19a4bda167efda5b790c2b52d3733a732bafcdccc9a5c76cd60a`

Download the release asset and flash the AnyKernel3 ZIP using a compatible recovery or kernel flasher.

> GitHub-generated `Source code` archives are not flashable kernel packages.

---

## Reporting Issues

When reporting a problem, include the kernel version, a short reproduction description and relevant logs such as `dmesg`, `logcat`, `pstore / ramoops`, or watchdog / panic logs when available.

[Open an issue](../../issues)

---

## Support Development

If you find **Equinox Kernel** useful and would like to support its continued development, donations are always appreciated but entirely optional.

<div align="center">

[![PayPal](https://img.shields.io/badge/PayPal-Support-003087?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.me/LF52406)
[![Patreon](https://img.shields.io/badge/Patreon-Support-FF424D?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/InfernalGT)
[![Boosty](https://img.shields.io/badge/Boosty-Support-F15F2C?style=for-the-badge&logo=boosty&logoColor=white)](https://boosty.to/infernalgt/donate)

</div>

---

## Credits & Upstreams

- [**LineageOS/android_kernel_xiaomi_sm8450**](https://github.com/LineageOS/android_kernel_xiaomi_sm8450) — primary kernel base used by Equinox
- [**LineageOS/android_kernel_qcom_sm8450**](https://github.com/LineageOS/android_kernel_qcom_sm8450) — Qualcomm common-kernel upstream used by Equinox
- [**Android Common Kernel**](https://android.googlesource.com/kernel/common) / [**Linux Kernel**](https://www.kernel.org/) — Android kernel infrastructure and upstream Linux
- [**KernelSU-Next**](https://github.com/KernelSU-Next/KernelSU-Next) — kernel root implementation
- [**SUSFS**](https://gitlab.com/simonpunk/susfs4ksu) by **simonpunk** / [**Zhanfg/susfs4ksu**](https://github.com/Zhanfg/susfs4ksu) — SUSFS integration for Linux 5.10
- [**DroidSpaces**](https://github.com/ravindu644/Droidspaces-OSS) by **ravindu644** — container runtime and kernel requirements
- [**Neutron Toolchains**](https://github.com/Neutron-Toolchains/clang-build-catalogue) — LLVM/Clang toolchain
- [**AnyKernel3**](https://github.com/osm0sis/AnyKernel3) by **osm0sis** — flashable kernel packaging
- [**BakaSU**](https://github.com/Baka-SU/BakaSU) (formerly ReSukiSU) — kernel root implementation of the BakaSU edition
- [**NoMount**](https://github.com/maxsteeel/nomount) by **maxsteeel**, with a fix by **deref3046** — VFS path redirection for the NoMount metamodule in the BakaSU edition
- **Nanairo** — BakaSU, SUSFS, BBR and NoMount integration of the BakaSU edition

Thanks to Qualcomm, LineageOS contributors, Android Common Kernel contributors, and the broader Linux kernel community for the upstream kernel, platform, and driver work that Equinox builds upon.
