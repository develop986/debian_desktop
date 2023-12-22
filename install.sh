#!/bin/bash

  echo "定番ソフトをインストールしますか？[Y/n]"

  read str

  if [[ $str =~ ^[yY]$ ]]; then
    echo "定番ソフトをインストールします。"
  else
    echo "定番ソフトをインストールしませんでした。"
    exit 0
  fi


# 日本時間、ロケール設定

  timedatectl set-timezone Asia/Tokyo && timedatectl status
  apt -y install task-japanese locales-all
  localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
  source /etc/default/locale 


# 自動アップデート設定

  echo 'Unattended-Upgrade::Automatic-Reboot "true";' >> /etc/apt/apt.conf.d/50unattended-upgrades
  echo 'Unattended-Upgrade::Automatic-Reboot-Time "05:00";' >> /etc/apt/apt.conf.d/50unattended-upgrades


# ホスト名変更

  echo "変更するホスト名を入力して下さい（空の場合は変更なし）"

  read str

  if [ "$str" = "" ]; then
    echo "ホスト名の変更はしませんでした。"
  else
    hostnamectl set-hostname "$str"
  fi


# スワップ設定

  echo "変更するスワップ領域をメガで入力して下さい（空の場合は変更なし）"

  read str

  if [[ "$str" =~ ^[0-9]+$ ]]; then
    dd if=/dev/zero of=/swapfile bs=1M count="$str"
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    sed -i '$ a /swapfile                                 swap                    swap    defaults        0 0' /etc/fstab
  else
    echo "スワップ領域の変更はしませんでした。"
  fi


# ユーザー追加

  echo "登録するユーザー名を入力して下さい（空の場合は登録なし）"

  read str

  if [[ "$str" =~ ^[a-z]+$ ]]; then
　　adduser "$str"
　　echo "$str　ALL=(ALL)　NOPASSWD:　ALL" > /etc/sudoers.d/"$str"
  else
    $str $USER
    echo "ユーザーの登録はしませんでしたので$strで処理を進めます。"
  fi


# 基本ソフトのインストール

  apt update && apt -y full-upgrade

  tasksel

  apt -y install zip unzip curl
  apt -y install git  etckeeper
  apt -y install rabbitvcs-core
  apt -y install fonts-noto-cjk fonts-noto-cjk-extra
  apt -y install gimp-plugin-registry gmic gimp-gmic inkscape diasudo
  apt -y install remmina 
  apt -y install xrdp tigervnc-standalone-server
  systemctl enable xrdp
  echo "X11Forwarding yes" >> /etc/ssh/sshd_config

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  apt -y install ./google-chrome-stable_current_amd64.deb 

  # 最新版が必要な場合は事前に変更しておくこと
  wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_120.0.2210.91-1_amd64.deb
  apt -y install ./microsoft-edge-stable_*_amd64.deb


# 後処理

  etckeeper init
  etckeeper commit "1st commit"

  update-alternatives --set editor /usr/bin/vim.tiny
  update-alternatives --set x-terminal-emulator /usr/bin/lxterminal

  su - "$str" -c 'git config --global user.email "kuhataku@gmail.com"'
  su - "$str" -c 'git config --global user.name "kuhataku"'

exit 0

