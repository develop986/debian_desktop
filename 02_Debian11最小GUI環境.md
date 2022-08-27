選択# Debian11 GUT最小インストール手順

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

Remminas（リモートデスクトップ接続アプリ）
sudo apt -y install remmina

RealVNC Viewer 
https://www.realvnc.com/en/connect/download/viewer/linux/

$ wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-6.22.515-Linux-x86.deb
$ wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-6.22.515-Linux-x64.deb
$ sudo apt install -y ./VNC-Viewer-*.deb
```