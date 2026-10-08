# Makefile for NoMount
# NoMount v2.1.0 by maxsteeel (https://github.com/maxsteeel/nomount, commit c7f63e3),
# vendored in-tree, plus:
#  - upstream fix 7e7342c by deref3046 (do not call ->evict_inode() on virtual inodes);
#  - Equinox BakaSU edition: processes that BakaSU/SUSFS umounted modules for see the
#    stock filesystem, and no /sys/module/nomount/version when built in.
# Upstream reads the commit count with git, which here would count this kernel tree
# instead; it is fixed to the upstream count so `nm version` reports the same version
# as the v2.1.0 (500) release.

obj-$(CONFIG_NOMOUNT) += nomount.o
ccflags-y += -DNOMOUNT_COMMIT_COUNT=\"500\"
ccflags-y += -std=gnu11 -Wno-declaration-after-statement
