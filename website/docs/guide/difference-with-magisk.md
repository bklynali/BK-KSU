# Difference with Magisk

Although BK-KSU and Magisk modules have many similarities, there are inevitably some differences due to their completely different implementation mechanisms. If you want your module to work on both Magisk and BK-KSU, it's essential to understand these differences.

## Similarities

- Module file format: Both use the ZIP format to organize modules, and the module format is practically the same.
- Module installation directory: Both are located at `/data/adb/modules`.
- Systemless: Both support modifying `/system` in a systemless way through modules.
- post-fs-data.sh: Execution time and semantics are exactly the same.
- service.sh: Execution time and semantics are exactly the same.
- system.prop: Completely the same.
- sepolicy.rule: Completely the same.
- BusyBox: Scripts are run in BusyBox with "Standalone Mode" enabled in both cases.

## Differences

Before understanding the differences, it's important to know how to identify whether your module is running in BK-KSU or Magisk. You can use the environment variable `KSU` to differentiate it in all places where you can run module scripts (`customize.sh`, `post-fs-data.sh`, `service.sh`). In BK-KSU, this environment variable will be set to `true`.

Here are some differences:

- BK-KSU modules cannot be installed in Recovery mode.
- BK-KSU modules don't have built-in support for Zygisk, but you can use Zygisk modules through [ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext).
- **Module mounting architecture**: BK-KSU uses a [metamodule system](metamodule.md) where mounting is delegated to pluggable metamodules (e.g., `meta-overlayfs`), while Magisk has mounting built into its core. BK-KSU requires installing a metamodule to enable module mounting.
- The method for replacing or deleting files in BK-KSU modules is completely different from Magisk. BK-KSU doesn't support the `.replace` method. Instead, you need to create a same-named file with `mknod filename c 0 0` to delete the corresponding file.
- The directories for BusyBox are different. The built-in BusyBox in BK-KSU is located at `/data/adb/ksu/bin/busybox`, while in Magisk it is at `/data/adb/magisk/busybox`. **Note that this is an internal behavior of BK-KSU and may change in the future!**
- BK-KSU doesn't support `.replace` files, but it supports the `REMOVE` and `REPLACE` variables to remove or replace files and folders.
- BK-KSU adds the `boot-completed` stage to run scripts after the boot process is finished.
- BK-KSU adds the `post-mount` stage to run scripts after module mounting is complete.
