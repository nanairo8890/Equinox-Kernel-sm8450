# Makefile for NoMount
# NoMount v2.1.1 by maxsteeel (https://github.com/maxsteeel/nomount, commit 7046c7a),
# vendored in-tree, plus the Equinox BakaSU edition changes: processes that
# BakaSU/SUSFS umounted modules for see the stock filesystem, and no
# /sys/module/nomount/version when built in.
# Upstream reads the commit count with git, which here would count this kernel tree
# instead; it is fixed to the upstream count so `nm version` reports the same version
# as the v2.1.1 (555) release.
# Upstream also passes -fno-stack-protector, which is for its prebuilt LKMs; built in,
# NoMount keeps the kernel's stack protector.

obj-$(CONFIG_NOMOUNT) += nomount.o
ccflags-y += -DNOMOUNT_COMMIT_COUNT=\"555\"
ccflags-y += -std=gnu11 -Wno-declaration-after-statement -O3
