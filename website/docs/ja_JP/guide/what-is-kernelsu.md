# BK-KSU とは?

BK-KSU は Android GKI デバイスのための root ソリューションです。カーネルモードで動作し、カーネル空間で直接ユーザー空間アプリに root 権限を付与します。

## 機能

BK-KSU の最大の特徴は、**カーネルベース**であることです。BK-KSU はカーネルモードで動作するため、今までにないカーネルインターフェイスを提供できます。例えば、カーネルモードで任意のプロセスにハードウェアブレークポイントを追加できる、誰にも気づかれずに任意のプロセスの物理メモリにアクセスできる、カーネル空間で任意のシステムコールを傍受できる、などです。

さらに、BK-KSU は [metamodule システム](metamodule.md) を提供しています。これはモジュール管理のためのプラグ可能なアーキテクチャです。従来の root ソリューションがマウントロジックをコアに組み込むのとは異なり、BK-KSU はこの作業を metamodule に委任します。これにより、metamodule ([meta-overlayfs](https://github.com/bklynali/BK-KSU/tree/main/userspace/meta-overlayfs)など) をインストールして、`/system`パーティションや他のパーティションへのsystemless変更を提供できます。

## 使用方法

こちらをご覧ください: [インストール方法](installation)

## ビルド方法

[ビルドするには](../../guide/how-to-build)

## ディスカッション

- Telegram: [@BK-KSU](https://t.me/BK-KSU)
