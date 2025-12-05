---
layout: home
title: Início

hero:
  name: BK-KSU
  text: Uma solução root baseada em kernel para Android
  tagline: ""
  image:
    src: /logo.png
    alt: BK-KSU
  actions:
    - theme: brand
      text: Iniciar
      link: /pt_BR/guide/what-is-BK-KSU
    - theme: alt
      text: Ver no GitHub
      link: https://github.com/bklynali/BK-KSU

features:
  - title: Baseado em kernel
    details: Como o nome sugere, BK-KSU funciona no kernel Linux, dando-lhe mais controle sobre os apps do espaço do usuário.
  - title: Controle de acesso root
    details: Somente apps permitidos podem acessar ou ver su, todos os outros apps não estão cientes disso.
  - title: Privilégios root personalizáveis
    details: BK-KSU permite a personalização de su, uid, gid, grupos, capacidades e regras do SELinux, bloqueando privilégios root.
  - title: Sistema Metamodule
    details: Infraestrutura de módulos plugável permite modificações systemless em /system. Instale um metamodule como meta-overlayfs para habilitar a montagem de módulos.
