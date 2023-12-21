# Debian11最小GUT環境構築

> シンクライアントを意識した構成ですので  
> お勧めはできません

### インストール

- Debianインストーラーでは、必要であれば`SSH サーバ`のみ選択

```
ベース環境
sudo apt -y install xorg lightdm openbox
sudo apt -y install fonts-noto-cjk fonts-noto-cjk-extra
sudo apt -y install wget curl
sudo apt -y install pulseaudio pavucontrol
sudo apt -y install firmware-linux-nonfree firmware-realtek

Remmina（リモートデスクトップ接続アプリ）
sudo apt -y install remmina

RealVNC Viewer 
https://www.realvnc.com/en/connect/download/viewer/linux/

$ wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-6.22.515-Linux-x86.deb
$ wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-6.22.515-Linux-x64.deb
$ sudo apt install -y ./VNC-Viewer-*.deb
```

### 課題

- Remmina で音声が出力されない
  - windows側はバーチャルオーディオを認識している
  - Debian側はバーチャルオーディオを認識していない
  - Remmina側が、バーチャルオーディオを認識していない
- RealVNC 接続できない
  - 192.168.1.11 に接続できない
  - サインインしても接続できない
- 無線LAN接続設定が必要