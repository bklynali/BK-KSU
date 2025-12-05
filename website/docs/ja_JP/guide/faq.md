# よくある質問

## 私のデバイスは BK-KSU に対応していますか?

まず、お使いのデバイスがブートローダーのロックを解除できる必要があります。もしできないのであれば、サポート外です。

もし BK-KSU アプリで「非対応」と表示されたら、そのデバイスは最初からサポートされていないことになりますが、カーネルソースをビルドして BK-KSU を組み込むか、[非公式の対応デバイス](unofficially-support-devices)で動作させることが可能です。

## BK-KSU を使うにはブートローダーのロックを解除する必要がありますか？

はい。

## BK-KSU はモジュールに対応していますか?

はい。ほとんどの Magisk モジュールは BK-KSU で動作します。ただし、モジュールが `/system` ファイルを変更する必要がある場合は、[metamodule](metamodule.md) (`meta-overlayfs`など) をインストールする必要があります。他のモジュール機能は metamodule なしで動作します。詳細は [モジュールガイド](module.md) をご覧ください。

## BK-KSU は Xposed に対応していますか?

はい。[Dreamland](https://github.com/canyie/Dreamland) や [TaiChi](https://taichi.cool) が動作します。LSPosed については、[ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext) を使うと動作するようにできます。

## BK-KSU は Zygisk に対応していますか?

BK-KSU は Zygisk サポートを内蔵していません。[ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext) を使ってください。

## BK-KSU は Magisk と互換性がありますか?

BK-KSU のモジュールシステムは Magisk のマジックマウントと競合しており、BK-KSU で有効になっているモジュールがある場合、Magisk 全体が動作しなくなります。

しかし、BK-KSU の `su` だけを使うのであれば、Magisk とうまく連携することができます。BK-KSU は `kernel` を、Magisk は `ramdisk` を修正するため、両者は共存できます。

## BK-KSU は Magisk の代わりになりますか？

私たちはそうは思っていませんし、それが目標でもありません。Magisk はユーザ空間の root ソリューションとして十分であり、長く使われ続けるでしょう。BK-KSU の目標は、ユーザーにカーネルインターフェースを提供することであり、Magisk の代用ではありません。

## BK-KSU は GKI 以外のデバイスに対応できますか？

可能です。ただしカーネルソースをダウンロードし、BK-KSU をソースツリーに統合して、自分でカーネルをビルドする必要があります。

## BK-KSU は Android 12 以下のデバイスに対応できますか？

BK-KSU の互換性に影響を与えるのはデバイスのカーネルであり、Android のバージョンとは無関係です。唯一の制限は、Android 12 で発売されたデバイスはカーネル5.10以上（GKI デバイス）でなければならないことです：

1. Android 12 をプリインストールして発売された端末は対応しているはずです。
2. カーネルが古い端末（一部の Android 12 端末はカーネルも古い）は対応可能ですが、カーネルは自分でビルドする必要があります。

## BK-KSU は古いカーネルに対応できますか？

BK-KSU は現在カーネル4.14にバックポートされていますが、それ以前のカーネルについては手動でバックポートする必要があります。プルリクエスト歓迎です！

## 古いカーネルに BK-KSU を組み込むには？

[ガイド](../../guide/how-to-integrate-for-non-gki) を参考にしてください。

## Android のバージョンが13なのに、カーネルは「android12-5.10」と表示されるのはなぜ？

カーネルのバージョンは Android のバージョンと関係ありません。カーネルを書き込む必要がある場合は、常にカーネルのバージョンを使用してください。Android のバージョンはそれほど重要ではありません。

## BK-KSU に-mount-master/global のマウント名前空間はありますか？

今はまだありませんが（将来的にはあるかもしれません）、グローバルマウントの名前空間に手動で切り替える方法は、以下のようにたくさんあります：

1. `nsenter -t 1 -m sh` でシェルをグローバル名前空間にします。
2. `nsenter --mount=/proc/1/ns/mnt` を実行したいコマンドに追加すればグローバル名前空間で実行されます。 BK-KSU は [このような使い方](https://github.com/bklynali/BK-KSU/blob/77056a710073d7a5f7ee38f9e77c9fd0b3256576/manager/app/src/main/java/me/weishu/BK-KSU/ui/util/KsuCli.kt#L115) もできます。

## GKI 1.0 なのですが、使えますか？

GKI1 は GKI2 と全く異なるため、カーネルは自分でビルドする必要があります。

## 新規インストール後にモジュールが動作しないのはなぜですか？

モジュールが `/system` ファイルを変更する必要がある場合は、`system` ディレクトリをマウントするために [metamodule](metamodule.md) をインストールする必要があります。他のモジュール機能（スクリプト、sepolicy、system.prop）は metamodule なしで動作します。

**解決策**：インストール手順については [Metamodule ガイド](metamodule.md) をご覧ください。

## metamodule とは何ですか？なぜ必要なのですか？

Metamodule は、通常のモジュールをマウントするためのインフラストラクチャを提供する特殊なモジュールです。完全な説明については [Metamodule ガイド](metamodule.md) をご覧ください。
