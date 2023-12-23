#!/bin/bash

# セットアップ作業開始確認
  echo 'Do you want to start the setup process? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    echo 'Start the setup process.'
  else
    echo 'Cancels the setup process.'
    exit 0
  fi

# パッケージの最新化
  echo 'Would you like to update your packages? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    apt update && apt -y full-upgrade
    update-alternatives --set editor /usr/bin/vim.tiny
    echo 'We have updated the package.'
  else
    echo 'I skipped updating the package.'
  fi

# 日本時間設定

  echo 'Do you want to set Japan time? [Y/n]'
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
  echo 'Would you like to set the Japanese locale? [Y/n]'
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
  echo 'Would you like to configure automatic APT update settings? [Y/n]'
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
  echo 'Do you want to change the host name? (If not entered, it will not be implemented)'
  read str
  if [ "$str" = "" ]; then
    echo 'I skipped setting the hostname.'
  else
    echo 'The host name has been changed.'
    hostnamectl set-hostname "$str"
  fi

# スワップ領域作成
  echo 'Please enter the swap area to be created in mega value (it will not be created if not entered)'
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
  echo 'Select the GUI desktop to install. (Otherwise skip installation)'
  echo '1: LXDE'
  echo '2: GNOME'
  echo '3: MATE'
  read str
  case "$str" in
    "1" )
      apt -y install task-lxde-desktop
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
    apt -y install gimp-plugin-registry gmic gimp-gmic inkscape diasudo
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
    echo 'Please select the development environment to install.'
    echo '11：PG JAVA OpenJDK'
    echo '12：PG JAVA Maven'
    echo '13：PG JAVA Gradle'
    echo '14：PG NodeJS'
    echo '31：DB PostgreSQL'
    echo '32：DB MySQL'
    echo '33：DB MariaDB'
    echo '34：DB SQLite3'
    echo '35：DB MongoDB'
    echo 'q：Exit'
    read str
    if [ "$str" = "q" ]; then
      break
    else
      case "$str" in
        "11" )
          apt -y install default-jdk
          echo 'export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")' >> /etc/bash.bashrc
          echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/bash.bashrc
          source /etc/bash.bashrc
          java -version
          javac -version
          echo 'I have installed JAVA OpenJDK.'
          ;;
        "12" )
          apt -y install maven
          maven -version
          echo 'I have installed JAVA Maven.'
          ;;
        "13" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://services.gradle.org/distributions/gradle-8.5-bin.zip
          mkdir /opt/gradle
          unzip -d /opt/gradle ./gradle-8.5-bin.zip
          echo 'export PATH=$PATH:/opt/gradle/gradle-8.5/bin' > /etc/profile.d/gradle.sh
          source /etc/profile.d/gradle.sh
          gradle -v
          echo 'I have installed JAVA Gradle.'
          ;;
        "14" )
          curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
          apt -y install nodejs
          node -v
          npm -v
          echo 'I have installed NodeJS.'
          ;;
        "31" )
          apt -y install postgresql
          echo 'I have installed PostgreSQL.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=postgresql'
          ;;
        "32" )
          # 最新版が必要な場合は事前に変更しておくこと 
          wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
          apt -y install ./mysql-apt-config_*.deb
          apt update
          apt -y install mysql-server
          dpkg-reconfigure mysql-apt-config
          apt update
          apt -y install mysql-workbench libmysqlclient21
          rm -r /var/lib/mysql/*
          mysqld --initialize-insecure --user=mysql
          echo 'bind-address=127.0.0.1' > /var/lib/mysql/my.ini 
          systemctl restart mysql
          systemctl status mysql
          echo 'I have installed MySQL.'
          echo 'https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/'
          ;;
        "33" )
          apt -y install mariadb-server 
          mysql_secure_installation 
          echo 'I have installed MariaDB.'
          echo 'https://www.server-world.info/query?os=Debian_12&p=mariadb&f=1'
          ;;
        "34" )
          apt -y install sqlite3
          sqlite3 -version
          echo 'I have installed SQLite3.'
          echo 'https://qiita.com/Nats72/items/4a420d7a54a0f67aa0cd'
        "35" )
          # 最新版が必要な場合は事前に変更しておくこと 
          apt -y install gnupg curl
          curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
            gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
          echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | \
            tee /etc/apt/sources.list.d/mongodb-org-7.0.list
          apt update
          apt -y install mongodb-org
          wget https://downloads.mongodb.com/compass/mongodb-compass_1.41.0_amd64.deb
          apt -y install ./mongodb-compass_*_amd64.deb
          echo 'I have installed MongoDB.'
          echo 'https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/'
          ;;
      esac
    fi
  done


# ユーザー追加
  echo 'Please enter the account name of the user to be created. (Does not create if empty)'
  read str
  if [[ "$str" =~ ^[a-z]+$ ]]; then
    adduser "$str"
    echo "$str ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$str"
    su - "$str" -c 'git config --global user.email "kuhataku@gmail.com"'
    su - "$str" -c 'git config --global user.name "kuhataku"'
    echo 'Created a user.'
    Created a user.
  else
    echo 'User creation skipped.'
  fi

# 再起動確認
  echo 'Do you want to reboot at the end? [Y/n]'
  read str
  if [[ "$str" =~ ^[yY]$ ]]; then
    echo 'Perform a reboot.'
    reboot
  else
    echo 'Please reboot to reflect the settings.'
    exit 0
  fi

exit 0

