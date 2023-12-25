#!/bin/bash

# セットアップ作業開始確認
  echo 'Do you want to start the SETUP process? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    echo 'Start the setup process.'
  else
    echo 'Cancels the setup process.'
    exit 0
  fi

# パッケージの最新化
  echo 'Would you like to UPDATE your packages? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    apt update && apt -y full-upgrade
    update-alternatives --set editor /usr/bin/vim.tiny
    echo 'We have updated the package.'
  else
    echo 'I skipped updating the package.'
  fi

# 日本時間設定

  echo 'Do you want to set JAPAN TIME? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    timedatectl set-timezone Asia/Tokyo
    timedatectl status
    date
    echo 'We have set the Japan time.'
  else
    date
    echo 'I skipped setting Japan time.'
  fi

# 日本語ロケール設定
  echo 'Would you like to set the JAPANESE LOCALE? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    apt -y install task-japanese locales-all
    localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
    source /etc/default/locale 
    date
    echo 'Japanese locale settings have been implemented.'
  else
    echo 'I skipped setting the Japanese locale.'
  fi

# APT自動アップデート設定
  echo 'Would you like to configure automatic APT UPDATE settings? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    apt -y install unattended-upgrades apt-listchanges
    dpkg-reconfigure -plow unattended-upgrades
    echo 'Unattended-Upgrade::Mail "root";' >> /etc/apt/apt.conf.d/50unattended-upgrades
    echo 'Unattended-Upgrade::Automatic-Reboot "true";' >> /etc/apt/apt.conf.d/50unattended-upgrades
    echo 'Unattended-Upgrade::Automatic-Reboot-Time "05:00";' >> /etc/apt/apt.conf.d/50unattended-upgrades
    echo 'APT automatic update settings have been implemented.'
  else
    echo 'APT auto-update settings have been skipped.'
  fi

# ホスト名変更
  echo 'Do you want to change the HOSTNAME? (If not entered, it will not be implemented)'
  read str
  if [ "$str" = "" ]; then
    echo 'I skipped setting the hostname.'
  else
    echo 'The host name has been changed.'
    hostnamectl set-hostname "$str"
  fi

# スワップ領域作成
  echo 'Please enter the SWAP area to be created in MEGA value (it will not be created if not entered)'
  read str
  if [[ "$str" =~ ^[0-9]+$ ]]; then
    dd if=/dev/zero of=/swapfile bs=1M count="$str"
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    sed -i '$ a /swapfile                                 swap                    swap    defaults        0 0' /etc/fstab
    free -h
    echo 'I created a swap area.'
  else
    free -h
    echo 'Skip creating swap space.'
  fi

# CUIソフトのインストール
  echo 'Do you want to install CUI software? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    apt -y install zip unzip curl
    apt -y install git etckeeper
    etckeeper init
    etckeeper commit "1st commit"
    apt -y install fonts-noto-cjk fonts-noto-cjk-extra
    echo 'We have installed CUI software.'
  else
    echo 'I skipped installing the CUI software.'
  fi

# GUIデスクトップのインストール
  echo 'Select the GUI DESKTOP to install. (Otherwise skip installation)'
  echo '1: LXDE'
  echo '2: GNOME'
  echo '3: MATE'
  read str
  case "$str" in
    "1" )
      echo 'If communication is interrupted, REBOOT.'
      apt -y install task-lxde-desktop fcitx-mozc && \
        systemctl restart connman.service
      # 何故かネットワークが切れるのでconnmanを再起動する
      echo 'I installed LXDE.'
      ;;
    "2" )
      apt -y install task-gnome-desktop
      echo 'I installed GNOME.'
      ;;
    "3" )
      apt -y install task-mate-desktop
      echo 'I installed MATE.'
      ;;
    * )
      echo 'I skipped installing the GUI desktop.'
      ;;
  esac

# GUIソフトのインストール
  echo 'Do you want to install GUI software? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    # rabbitvcs-nautilus は現在unstableであるため、インストール不可
    # apt -y install rabbitvcs-core rabbitvcs-nautilus rabbitvcs-thunar rabbitvcs-gedit rabbitvcs-cli
    apt -y install gimp-plugin-registry gmic gimp-gmic inkscape dia
    apt -y install remmina 

    apt -y install xrdp tigervnc-standalone-server
    systemctl enable xrdp
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt -y install ./google-chrome-stable_current_amd64.deb 

    # 最新版が必要な場合は事前に変更しておくこと
    wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_120.0.2210.91-1_amd64.deb
    apt -y install ./microsoft-edge-stable_*_amd64.deb

    curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o vscode.deb
    apt -y install ./vscode.deb

    wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    apt -y install ./dbeaver-ce_latest_amd64.deb

    echo 'We have installed GUI software.'
  else
    echo 'I skipped installing the GUI software.'
  fi

# 開発環境のインストール
  while :
  do
    echo 'Please select the DEVELOPMENT environment to install.'
    echo 'P1：PG JAVA OpenJDK  ('`which javac`')'
    echo 'P2：PG JAVA Maven  ('`which mvn`')'
    echo 'P3：PG JAVA Gradle  ('`which gradle`')'
    echo 'P4：PG NodeJS  ('`which node`')'
    echo 'D1：DB PostgreSQL  ('`which psql`')'
    echo 'D2：DB MySQL  ('`which mysql`')'
    echo 'D3：DB MariaDB  ('`which mysql`')'
    echo 'D4：DB SQLite3  ('`which sqlite3`')'
    echo 'D5：DB MongoDB  ('`which mongod`')'
    echo 'I1：IDE(GUI) Eclipse'
    echo 'I2：IDE(GUI) Android Studio'
    echo 'V1：VM KVM  ('`lsmod | grep kvm | head -1`')'
    echo 'V2：VM Docker Engine  ('`which docker`')'
    echo 'T1: TOOL(GUI) MySQL Workbench'
    echo 'T2: TOOL(GUI) MongoDB Compass'
    echo 'T3: TOOL(GUI) Virtual Machine Manager'
    echo 'q：Exit'
    read str
    if [ "$str" = "q" ]; then
      break
    else
      case "$str" in
        "P1" )
          apt -y install default-jdk
          echo 'export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")' >> /etc/bash.bashrc
          echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/bash.bashrc
          echo 'export CLASSPATH=.:$JAVA_HOME/lib/' >> /etc/bash.bashrc 
          source /etc/bash.bashrc
          java -version
          javac -version
          echo 'I have installed JAVA OpenJDK.'
          ;;
        "P2" )
          apt -y install maven
          mvn -v
          echo 'I have installed JAVA Maven.'
          echo 'https://www.linuxcapable.com/how-to-install-apache-maven-on-debian-linux/'
          ;;
        "P3" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://services.gradle.org/distributions/gradle-8.5-bin.zip
          mkdir /opt/gradle
          unzip -d /opt/gradle ./gradle-8.5-bin.zip
          echo 'export PATH=$PATH:/opt/gradle/gradle-8.5/bin' >> /etc/bash.bashrc
          source /etc/bash.bashrc
          gradle -v
          echo 'I have installed JAVA Gradle.'
          ;;
        "P4" )
          apt -y install nodejs npm 
          node -v
          npm -v
          echo 'I have installed NodeJS.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=nodejs&f=1'
          ;;
        "D1" )
          apt -y install postgresql
          psql --version
          echo 'I have installed PostgreSQL.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=postgresql'
          ;;
        "D2" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
          apt -y install ./mysql-apt-config_*.deb
          apt update
          apt -y install mysql-server
          rm -r /var/lib/mysql/*
          mysqld --initialize-insecure --user=mysql
          echo 'bind-address=127.0.0.1' > /var/lib/mysql/my.ini 
          systemctl restart mysql
          systemctl status mysql
          mysql --version
          echo 'I have installed MySQL.'
          echo 'https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/'
          ;;
        "D3" )
          apt -y install mariadb-server 
          mysql_secure_installation 
          mysql --version
          echo 'I have installed MariaDB.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=mariadb&f=1'
          ;;
        "D4" )
          apt -y install sqlite3
          sqlite3 -version
          echo 'I have installed SQLite3.'
          echo 'https://qiita.com/Nats72/items/4a420d7a54a0f67aa0cd'
          ;;
        "D5" )
          # 最新版が必要な場合は事前に変更しておくこと 
          apt -y install gnupg curl
          curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
            gpg -o /etc/apt/trusted.gpg.d/mongodb-server-7.0.gpg --dearmor
          echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
            tee /etc/apt/sources.list.d/mongodb-org-7.0.list
          apt update
          apt -y install mongodb-org
          mongod -version
          echo 'I have installed MongoDB.'
          echo 'https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/'
          echo 'https://medium.com/@arun0808rana/mongodb-installation-on-debian-12-8001d0dafb56'
          ;;
        "I1" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://mirror.kakao.com/eclipse/oomph/epp/2023-12/R/eclipse-inst-jre-linux64.tar.gz
          tar -xvf eclipse-inst-jre-linux64.tar.gz 
          # tar: 未知の拡張ヘッダキーワード 'LIBARCHIVE.creationtime' を無視
          ./eclipse-installer/eclipse-inst
          cd
          echo 'I have installed Eclipse.'
          echo 'https://www.eclipse.org/downloads/packages/installer'
          echo 'If you need to configure PLEIADES, please refer to the following.'
          echo 'https://willbrains.jp/'
          ;;
        "I2" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.3.1.21/android-studio-2022.3.1.21-linux.tar.gz
          tar -xvf android-studio-*-linux.tar.gz
          sh ./android-studio/bin/studio.sh
          # Startup Error
          # Unable to detect graphics environment
          echo 'I have installed Android Studio.'
          echo 'https://linux.how2shout.com/how-to-install-android-studio-on-debian-12-11-linux/'
          ;;
        "V1" )
          vm=`cat /proc/cpuinfo | grep -e vmx -e svm | wc -l`
          echo "VM Count $vm"
          if [ "$vm" -gt 0 ]; then
            apt -y install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin
            lsmod | grep kvm
            echo 'I have installed KVM.'
          else
            echo 'KVM cannot be installed because the CPU does not support virtualization.'
          fi
          echo 'https://www.server-world.info/query?os=Debian_12&p=kvm'
          ;;
        "V2" )
          apt -y install ca-certificates curl gnupg
          install -m 0755 -d /etc/apt/keyrings
          curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
          chmod a+r /etc/apt/keyrings/docker.gpg
          echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            tee /etc/apt/sources.list.d/docker.list > /dev/null
          apt update
          apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
          docker run hello-world
          echo 'I have installed Docker Engine.'
          echo 'https://docs.docker.com/engine/install/debian/'
          ;;
        "T1" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget 'https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.34-1ubuntu23.04_amd64.deb'
          apt -y install ./mysql-workbench-community_*_amd64.deb
          echo 'I have installed MySQL Workbench.'
          echo 'https://www.mysql.com/jp/products/workbench/'
          ;;
        "T2" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://downloads.mongodb.com/compass/mongodb-compass_1.41.0_amd64.deb
          apt -y install ./mongodb-compass_*_amd64.deb
          echo 'I have installed MongoDB Compass.'
          echo 'https://www.mongodb.com/products/tools/compass'
          ;;
        "T3" )
          apt -y install virt-manager qemu-system
          echo 'I have installed Virtual Machine Manager.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=kvm&f=3'
          ;;
      esac
    fi
  done


# ユーザー追加
  echo 'Please enter the account name of the USER to be created. (Does not create if empty)'
  read str
  if [[ "$str" =~ ^[a-z]+$ ]]; then
    adduser "$str"
    echo "$str ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$str"
    su - "$str" -c 'git config --global user.email "kuhataku@gmail.com"'
    su - "$str" -c 'git config --global user.name "kuhataku"'
    usermod -aG docker "$str"
    echo 'Created a user.'
    Created a user.
  else
    echo 'User creation skipped.'
  fi

# 再起動確認
  echo 'Do you want to REBOOT at the end? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    echo 'Perform a reboot.'
    reboot
  else
    echo 'Please reboot to reflect the settings.'
    exit 0
  fi

exit 0

