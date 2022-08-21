## Dockerfileでデスクトップ環境を作る

[DockerでDebian 11(Bullseye)のLXDEデスクトップ環境にリモートデスクトップで接続できるコンテナを作成する](http://serverarekore.blogspot.com/2022/02/dockerdebian-11bullseyelxde.html)

> 先に[Dockerfile](Dockerfile)のkuhara欄を、変更したいユーザー名とパスワードに変更する

```
１時間は掛かるので覚悟して実行する
$ docker build --no-cache -t debian11lxde .
$ docker history debian11lxde

$ docker image ls

ホート開放する場合は、localhost:13389 で接続（リモートデスクトップ）
$ docker create --name testdebian -p 13389:3389 debian11lxde

ポート開放しない場合は、172.17.0.2 で接続（おそらく）
$ docker create --name testdebian debian11lxde

$ docker start testdebian

纏めて実行するには、run
$ docker run -itd --name testdebian debian11lxde

ターミナル接続
$ docker exec -it testdebian bash

イメージにコミット
$ docker stop testdebian
$ docker commit testdebian debian11lxde-1
$ docker images

$ docker rm testdebian
$ docker ps -a
$ docker image rm debian11lxde-1
$ docker images
```

## DockerHub にプッシュ

まずはアカウントを作成する  
[Docker Hub Container Image Library](https://hub.docker.com)  

```
$ docker tag debian11lxde-1 develop986/debianlxde:latest
$ docker images

$ docker login
$ docker push develop986/debianlxde:latest

pullでイメージを取得
$ docker pull develop986/debianlxde:latest
```

## Docker内の共有ボリュームをマウント

```
$ docker volume create docker-disk
$ docker volume ls
$ docker volume inspect docker-disk

--mount または -v でマウント
$ docker run -itd --name testdebian-1 --mount source=docker-disk,target=/app debian11lxde
$ docker run -itd --name testdebian-2 --mount source=docker-disk,target=/app debian11lxde
$ docker ps
$ docker stop testdebian-1
$ docker stop testdebian-2
$ docker rm testdebian-1
$ docker rm testdebian-2

$ docker volume rm docker-disk
```

## ホスト内の共有ボリュームをマウント

```
-v だと初回はディスクを生成する
$ docker run -itd --name testdebian-1 -v "$(pwd)"/mount:/app debian11lxde
$ docker run -itd --name testdebian-2 --mount type=bind,source="$(pwd)"/mount,target=/app debian11lxde

強制削除
$ docker rm -f testdebian-1
$ docker rm -f testdebian-2
```

## tmpfsをマウント（コンテナ停止で削除される、共有できない）

```
--tmpfs はオプションが指定できない
$ docker run -itd --name testdebian-1 --mount type=tmpfs,destination=/app,tmpfs-size=800000000,tmpfs-mode=1777 debian11lxde
$ docker run -itd --name testdebian-2 --tmpfs /app debian11lxde
$ docker rm -f testdebian-1
$ docker rm -f testdebian-2
```

### DockerでDebianデスクトップ環境構築（VPSでの作業）

> - [Dockerインストール](https://github.com/develop986/ubuntu_server/blob/main/02.Docker.md) 
> - let's encrypt での SSL取得  
> まで終わらせておくこと

```
$ sudo su -
# git clone https://github.com/develop986/debian_desktop
# cd debian_desktop
# git pull
# docker compose up -d
```

### 動作確認

```
# sudo docker exec -it debian-desktop bin/bash

リモートデスクトップに以下で接続
mysv986.com
```

### 削除する場合

```
# docker compose down -v
# docker image rm -f debian_desktop_debian
'''