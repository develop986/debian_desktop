# Debian Desktop 開発環境構築手順

## はじめに

> 開発は普通、WindowsかMacでするものと思いますが、  
> 私は家では普段、[Debian](https://ja.wikipedia.org/wiki/Debian)という
> [Linux](https://ja.wikipedia.org/wiki/Linux)のデスクトップ環境で  
> JavaやJavaScriptの勉強をしています。  
> Linuxというと、会社でよく使っているのは [Red Hat Enterprise Linux (RHEL)](https://ja.wikipedia.org/wiki/Red_Hat_Enterprise_Linux) か、  
> [CentOS](https://ja.wikipedia.org/wiki/CentOS) だと思います。   
> 
> しかし、RHEL を使うにはライセンス契約が必要ですし、CentOSは、知っての通り、  
> 長期サポートが無くなっています。  
> そこでお勧めしたいのが、Debianです。  

## Debian11、LXDE、デスクトップ環境イメージ

![](/img/Debian11_LXDE_032.png)

## 開発環境用途

> 主にWebシステム開発を想定しています  
> 今後もインストール手順を追加予定です

- Java関連
- Node.js関連

## なぜDebianか？

> 数多く存在する[Linuxディストリビューション](https://ja.wikipedia.org/wiki/Linux%E3%83%87%E3%82%A3%E3%82%B9%E3%83%88%E3%83%AA%E3%83%93%E3%83%A5%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3)には、大きく  
> - Debian系
> - Red Hat系（RHEL、CentOS等）
> - Slackware系  
> 
> の3系統が存在しますが、近年勢いのある[Ubuntu](https://ja.wikipedia.org/wiki/Ubuntu)や、
[Raspberry Pi OS](https://ja.wikipedia.org/wiki/Raspberry_Pi_OS)は、
Debian系です。  
> 
> また、Debianが標準でサポートしているソフトは、[GNUプロジェクト](https://ja.wikipedia.org/wiki/GNU%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)に則った、  
> 100%フリーソフトウェアのみです。  
> しかもNon-Free パッケージも提供しており、Ubuntuとほぼ同じソフトが使えます。  
> ライセンス契約は不要ですし、現行版のDebian11は、2026年までサポートされる予定です。  

## Debianの特徴

> - `apt`コマンドでのパッケージ管理（RHELの、`yum`、`dnf`に相当）
> - `apt full-upgrade`コマンドでの、OSバージョンアップができる。(事前準備は必要)
> - [x64](https://ja.wikipedia.org/wiki/X64)だけでなく、[x86](https://ja.wikipedia.org/wiki/X86)や、[ARM](https://ja.wikipedia.org/wiki/ARM%E3%82%A2%E3%83%BC%E3%82%AD%E3%83%86%E3%82%AF%E3%83%81%E3%83%A3)もサポートしている
> - 標準でサポートするソフトウェアは、恐らくRHELやCentOSよりも多い
> - GNOME、Xfce、KDE、Cinnamon、MATE、LXDE、LXQt等の、複数のデスクトップ環境をサポート
> - LXDE等の軽量デスクトップ環境を選べば、低スペックマシンでも実用可能

## Linuxデスクトップ環境の利点

> - 有償ライセンス不要なので、VirtualBox等に簡単に開発環境を導入できる
> - Windowsに比べ、軽量に動く（CPUは半分程度、メモリ4Gのスペックで十分）
> - 仮想デスクトップ環境であれば、クローン作成や、作り直しが簡単にできる
> - 開発環境と本番環境を、どちらもLinuxソフトウェアに合わせることができる
> - [Visual Studio Code（以下VSCode）](https://ja.wikipedia.org/wiki/Visual_Studio_Code)が使える
> - Google、Microsoft Exchange アカウント等との情報共有ができる
> - Linuxシェルが使える

## Linuxデスクトップ環境の欠点

> - Windowsとの操作感が違う（慣れが必要）
> - Excel等のOfficeが使えない（LibreOfficeやWeb版Exel等で代用？）
> - 使い慣れているソフトが使えない
>   - さくらエディタ（標準テキストエディタとVSCodeで代用可能）
>   - TortoiseSVN、TortoiseGit（RabbitVCS で代用可能）
>   - WinMerge（Meid で代用可能）
>   - A5:SQL Mk-2（DBeaver で代用可能）
>   - Eclipse、Pleiades（ある程度はVSCodeで代用可能）
>   - Windows関連コマンド（Linuxシェルの方が皆知っている）
>
> 逆に言うと、VSCodeしか使わないような環境であれば、  
> Linuxデスクトップ環境は、選択肢として検討できると思います。

## Debianデスクトップ環境構築マニュアル

0. [Downloading Debian](https://www.debian.org/download)
   - https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso
   - https://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-12.4.0-i386-netinst.iso
1. [VirtualBox 仮想PC作成](01_VirtualBox.md)
2. Debianインストール
   - [Debian11インストール](02_Debian11インストール.md)
   - [Debian11最小GUT環境構築](02_Debian11最小GUT環境構築.md)
   - [IndigoでのDebian12インストール](02_IndigoでのDebian12インストール.md)
3. [デスクトップ用途ソフトウェア](03_デスクトップソフト.md)
4. [開発用途ソフトウェア](04_開発用ソフト.md)
5. [仮想化関連ソフトウェア](05_仮想化ソフト.md)
6. [操作と設定](06_操作と設定.md)
7. [Dockerでデスクトップ環境を作る](07_Dockerでデスクトップ環境を作る.md)

## bashによる自動設定

```
$ wget https://raw.githubusercontent.com/develop986/debian_desktop/main/setting.sh && sudo bash setting.sh && rm setting.sh
```

## その他

- [Debian系ソフトの話](etc.md)










