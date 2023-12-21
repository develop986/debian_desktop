# IndigoでのDebian12インストール

https://indigo.arena.ne.jp/

- IPv6 Only Instance
- 1 vCPU
- 768 MB RAM
- 20 GB SSD
- 100 Mbps


## SSHで外部接続出来るようにする

```
& mkdir .ssh
& cp ~/ダウンロード/private_key.txt /home/kuhataku/.ssh/authorized_keys
$ chmod 600 .ssh/authorized_keys
$ rm .ssh/known_hosts*
$ ssh -i ~/.ssh/authorized_keys debian@indigo.debiancamp.com
$ sudo su -
```

## アップデート

```
# apt update && apt -y full-upgrade
# reboot
```

## 設定情報の履歴を取れるようにする

```
# apt install -y etckeeper
# etckeeper init
# etckeeper commit "1st commit"
```

## デフォルトエディタ変更

```
# update-alternatives --config editor
# update-alternatives --set editor /usr/bin/vim.basic
```

## 日本設定

```
# timedatectl set-timezone Asia/Tokyo
# timedatectl status
# apt -y install task-japanese locales-all
# localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
# source /etc/default/locale 
```

## ホスト名変更

```
# hostnamectl set-hostname debiancamp
```

## 自動アップデート設定

```
# vi /etc/apt/apt.conf.d/50unattended-upgrades

//Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot "true";
//Unattended-Upgrade::Automatic-Reboot-Time "02:00";
Unattended-Upgrade::Automatic-Reboot-Time "05:00";

# reboot
```

## SWAP設定

```
# free -m
# dd if=/dev/zero of=/swapfile bs=1M count=1024
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile
# sed -i '$ a /swapfile                                 swap                    swap    defaults        0 0' /etc/fstab
# free -m
# reboot
# free -m
```

## ユーザー作成

```
# adduser remoteadmin
# visudo
remoteadmin	ALL=(ALL)	NOPASSWD: ALL

# reboot
```

## LXDEインストール

```
& sudo apt -y install lxde task-lxde-desktop task-japanese-desktop ibus-kkc 
```

## Docker インストール

[Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/#install-using-the-repository)

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```