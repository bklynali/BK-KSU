---
layout: home
title: Home

hero:
  name: BK-KSU
  text: A kernel-based root solution for Android
  tagline: ""
  image:
    src: /logo.png
    alt: BK-KSU
  actions:
    - theme: brand
      text: Get started
      link: /guide/what-is-BK-KSU
    - theme: alt
      text: View on GitHub
      link: https://github.com/bklynali/BK-KSU

features:
  - title: Kernel-based
    details: As the name suggests, BK-KSU runs inside the Linux kernel, giving it more control over userspace apps.
  - title: Root access control
    details: Only permitted apps can access or see su; all other apps remain unaware of it.
  - title: Customizable root privileges
    details: BK-KSU allows customization of su's uid, gid, groups, capabilities, and SELinux rules, hardening root privileges.
  - title: Metamodule system
    details: Pluggable module infrastructure allows systemless /system modifications. Install a metamodule like meta-overlayfs to enable module mounting.
