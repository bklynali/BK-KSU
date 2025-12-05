# FAQ

## Does BK-KSU support my device?

BK-KSU supports devices running Android with an unlocked bootloader. However, official support is only for GKI Linux Kernels 5.10+ (in practice, this means your device needs to have Android 12 out-of-the-box to be supported).

You can easily check the support for your device through the BK-KSU Manager, which is available [here](https://github.com/bklynali/BK-KSU/releases). 

If the app shows `Not installed`, it means your device is officially supported by BK-KSU.

If the app shows `Unsupported`, it means your device isn't officially supported at present. However, you can build kernel source code and integrate BK-KSU to make it work, or use [Unofficially supported devices](unofficially-support-devices).

## Do I need to unlock the bootloader to use BK-KSU?

Yes. BK-KSU requires an unlocked bootloader.

## Does BK-KSU support modules?

Yes, most Magisk modules work on BK-KSU. However, if your module needs to modify `/system` files, you need to install a [metamodule](metamodule.md) (such as `meta-overlayfs`). Other module features work without a metamodule. Check [Module guide](module.md) for more info.

## Does BK-KSU support Xposed?

Yes, you can use LSPosed (or other modern Xposed derivative) with [ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext).

## Does BK-KSU support Zygisk?

BK-KSU has no built-in Zygisk support, but you can use a module like [ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext) to support it.

## Is BK-KSU compatible with Magisk?

BK-KSU's module system conflicts with Magisk's magic mount. If any module is enabled in BK-KSU, Magisk will stop working entirely.

However, if you only use the `su` of BK-KSU, it will work well with Magisk. BK-KSU modifies the `kernel`, while Magisk modifies the `ramdisk`, allowing both to work together.

## Will BK-KSU substitute Magisk?

No. Replacing Magisk isn't our goal. Magisk is already an excellent userspace root solution. BK-KSU focuses on exposing kernel interfaces to users instead of supplanting Magisk.

## Can BK-KSU support non-GKI devices?

It's possible. But you should download the kernel source, integrate BK-KSU into the source tree, and compile the kernel yourself.

## Can BK-KSU support devices below Android 12?

It's the device's kernel that affects BK-KSU's compatibility, and it has nothing to do with the Android version. The only restriction is that devices launched with Android 12 must have a kernel version of 5.10+ (GKI devices). So:

1. Devices launched with Android 12 must be supported.
2. Devices with an older kernel (some devices with Android 12 also have the older kernel) are compatible (you should build kernel yourself).

## Can BK-KSU support old kernel?

It's possible. BK-KSU is backported to kernel 4.14 now. For older kernels, you need to backport it manually, and PRs are always welcome!

## How to integrate BK-KSU for an older kernel?

Please check the [Integrate for non-GKI devices](how-to-integrate-for-non-gki) guide.

## Why my Android version is 13, and the kernel shows "android12-5.10"?

The kernel version has nothing to do with the Android version. If you need to flash kernel, always use the kernel version; the Android version isn't as important.

## I'm GKI 1.0, can I use this?

GKI 1.0 is completely different from GKI 2.0, you must compile kernel by yourself.

## How can I make `/system` RW?

We don't recommend that you modify the system partition directly. Please check [Module guide](module.md) to modify it systemlessly. If you insist on doing this, check [magisk_overlayfs](https://github.com/HuskyDG/magic_overlayfs).

## Can BK-KSU modify hosts? How can I use AdAway？

Of course. But BK-KSU doesn't have built-in hosts support, you can install a module like [systemless-hosts](https://github.com/symbuzzer/systemless-hosts-BK-KSU-module) to do it.

## Why aren't my modules working after fresh install?

If your modules need to modify `/system` files, you need to install a [metamodule](metamodule.md) to mount the `system` directory. Other module features (scripts, sepolicy, system.prop) work without a metamodule.

**Solution**: See the [Metamodule Guide](metamodule.md) for installation instructions.

## What is a metamodule and why do I need one?

A metamodule is a special module that provides infrastructure for mounting regular modules. See the [Metamodule Guide](metamodule.md) for a complete explanation.
