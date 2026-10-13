# Equinox Kernel BakaSU and NoMount Edition: Changelog

Edition by Nanairo8890, with permission from LF52406. Based on Equinox Kernel 5.10.269 for the POCO F5 Pro / Redmi K60 (`mondrian`).
Problems with this edition: report them to Nanairo8890, not to LF52406.

---

## 5.10.269 r3 (2026-10-13)

**Compatibility**
- Compatible with MistOS 5.1 Beta 17.0 (build 20261011), whose stock kernel is 5.10.269 (compiled with Clang r596125).
- Vendor module CRCs match the 337 `vendor_boot` and 390 `vendor_dlkm` modules of MistOS 5.1 Beta 20261011, and still match MistOS 5.0 Alpha 20260914.
- Installation is unchanged: the AnyKernel3 zip only replaces the `Image` and keeps the ROM's ramdisk, header and bootconfig. If you update MistOS, flash the zip again, because the ROM ships its own kernel.

**Changes**
- BakaSU updated to version 35229 (commit `e1682a28`, v4.2.0-rc3 + 58 commits). It comes from PR #624 "kernel: sync for latest susfs", which is not merged yet. BakaSU's `main` has blocked SUSFS builds since 10 October.
- Brings in the latest fixes from `main`, up to `64814408`: side-channel timing detection in `selinux_hide` and sidtab detection fixes, `track_throne` deferred to task_work, and `su` no longer redirected when `ksud` is missing.
- BakaSU manager 35229 (`BakaSU_v4.2.0-rc3_35229-arm64-v8a-release.apk`), from BakaSU's CI, signed with the same key as 35217. Manager 35217 still works, but updating is recommended.
- SUSFS updated to `82f08351` (v2.3.0). Only the hooks in `security/selinux/hooks.c`, `security/selinux/selinuxfs.c` and `fs/exec.c` changed. `fs/susfs.c` and the `ksu_susfs` commands are the same as r2, so BRENE and the other SUSFS modules work as before.
- NoMount updated to v2.1.1 by maxsteeel (`7046c7a`): faster rule lookup and directory listing, rules stored in one allocation per directory, virtual inodes independent of rules, `call_rcu()` for freeing, and use-after-free and out-of-range read fixes. The `7e7342c` fix from deref3046 is included.
- The `/proc/kallsyms` filter now also hides `dummy_key_instantiate` and `dummy_key_free_preparse`, which were visible in r2.
- Three edition-specific NoMount changes are kept: apps whose modules SUSFS/BakaSU unmounts see the original system, there is no `/sys/module/nomount/version`, and SUSFS's kallsyms filter hides NoMount symbols.
- NoMount is compiled with `-O3` as upstream, but without `-fno-stack-protector`, which upstream uses only for its own `.ko` builds.
- Installer: AnyKernel3 shows ASCII art of a mouse girl and the EQUINOX logo, with "BakaSU and NoMount Edition by Nanairo8890", before the kernel data.

**Verified on the phone** (POCO F5 Pro, MistOS 5.1 Beta 20261011)
- Boots. 0 vendor modules rejected (385 loaded). No errors in dmesg.
- BakaSU works with manager 35229. SUSFS v2.3.0 with all features active. BRENE works.
- SELinux in Enforcing mode.
- No `dummy_key_`, `nm_`, `nomount`, `ksu_` or `susfs_` symbols in `/proc/kallsyms`.
- To check after installing: `adb shell su -c "dmesg | grep -i 'disagrees about version'"` (should print nothing).

**Known NoMount issues (upstream, still open)**
- [#75](https://github.com/maxsteeel/nomount/issues/75): a `.replace` file or opaque directory inside a module can make a whole directory disappear and cause a bootloop. Before using NoMount, check that no module uses them: `su -c "find /data/adb/modules -name .replace"`.
- [#71](https://github.com/maxsteeel/nomount/issues/71): do not use NoMount to replace vendor `.ko` files.

---

## 5.10.269 r2 (2026-10-08)

**New: NoMount built into the kernel**
- [NoMount](https://github.com/maxsteeel/nomount) v2.1.0 by maxsteeel, built in (`CONFIG_NOMOUNT=y`), with the fix `7e7342c` from deref3046. NoMount redirects paths in the VFS layer instead of mounting with OverlayFS or Magic Mount, so no mount appears in `/proc/mounts`.
- Install the official metamodule `NoMount-v2.1.0-release-500.zip` from the BakaSU manager: https://github.com/maxsteeel/nomount/releases/tag/v2.1.0. KernelSU supports only one metamodule at a time, so uninstall Hybrid Mount or any other one first.
- Edition changes so that root is better hidden: processes whose modules are unmounted by BakaSU/SUSFS see the original system, there is no `/sys/module/nomount/version` (`nm version` still works), and SUSFS's kallsyms filter hides `nm_*`, `nomount*` and `__initstub__kmod_kernelsu`.

**Verified**
- Booted with `fastboot boot` on MistOS 5.0 Alpha 20260914 with manager 35217: 0 vendor modules rejected (385 loaded), root, zygisk modules, SUSFS and BRENE working, SELinux Enforcing, no kernel errors.
- NoMount tested with rules on `/system`: inject, replace, hide, UID isolation and clear, with no kernel warnings.

**Known NoMount issues (upstream)**: [#75](https://github.com/maxsteeel/nomount/issues/75) and [#71](https://github.com/maxsteeel/nomount/issues/71), as above.

---

## 5.10.269 r1 (2026-10-07)

**Changes from Equinox 5.10.269**
- **Root: BakaSU** instead of KernelSU-Next 3.4.0. BakaSU is the new name of ReSukiSU since 5 October 2026, used from commit `c9246641` (v4.2.0-rc3 + 46 commits, version 35217).
  - **Requires BakaSU manager 35217 or newer.** BakaSU uses version 5 of the kernel/`ksud` interface since 4 October.
- **SUSFS v2.3.0** from simonpunk's `gki-android12-5.10` branch, last commit `9892175` (26 September), using BakaSU's own SUSFS support.
- **BBR** is the default TCP congestion control (Equinox includes it but starts with CUBIC). CUBIC is still available and can be switched at runtime.

**Same as Equinox**
- Linux 5.10.269 with Equinox's mondrian config.
- DroidSpaces with Equinox's KMI-safe profile.
- Goodix touch fixes, Clang CFI and MODVERSIONS.
- AnyKernel3 installation.

**Technical details**
- Built with AOSP Clang (`clang-r584948`) and ThinLTO.
- Before packaging: KMI check against clean Equinox (0 changed CRCs, 0 removed symbols), and vendor module CRCs against MistOS 5.0 Alpha 20260914 (337 `vendor_boot` and 390 `vendor_dlkm` modules).
- `/proc/version` shows `Nanairo@Equinox`. SUSFS's `set_uname` only changes what `uname` returns.

**Compatibility**
- Tested on POCO F5 Pro with MistOS 5.0 Alpha 20260914 and manager 35217: boots, 0 vendor modules rejected (386 loaded), root, zygisk modules, SUSFS and BRENE working, SELinux Enforcing, no kernel errors.

---

## Credits
- **[LF52406](https://github.com/LF52406)**: Equinox Kernel, the base of this edition. Support: [PayPal](https://www.paypal.me/LF52406) · [Patreon](https://patreon.com/InfernalGT) · [Boosty](https://boosty.to/infernalgt/donate)
- [LineageOS](https://github.com/LineageOS/android_kernel_xiaomi_sm8450) and [Android Common Kernel](https://android.googlesource.com/kernel/common).
- [BakaSU](https://github.com/Baka-SU/BakaSU) (formerly ReSukiSU) and [KernelSU](https://github.com/tiann/KernelSU) by tiann.
- [SUSFS](https://gitlab.com/simonpunk/susfs4ksu) by **simonpunk**.
- [DroidSpaces](https://github.com/ravindu644/Droidspaces-OSS) by **ravindu644**.
- [NoMount](https://github.com/maxsteeel/nomount) by **maxsteeel**, with the fix `7e7342c` by **deref3046**.
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) by **osm0sis**.
- **[Nanairo8890](https://github.com/nanairo8890)**: BakaSU, SUSFS, BBR and NoMount integration into Equinox.
