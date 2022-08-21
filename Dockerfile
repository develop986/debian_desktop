FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt -y install vim less task-japanese locales-all \
  && echo 'LC_ALL=ja_JP.UTF-8' > /etc/default/locale \
  && echo 'LANG=ja_JP.UTF-8' >> /etc/default/locale \
  && apt install -y task-lxde-desktop \
  xrdp \
  supervisor \
  task-japanese-desktop \
  tzdata \
  fonts-ipafont \
  fonts-ipafont-gothic \
  fonts-ipafont-mincho \
  fcitx-mozc \
  iproute2 \
  iputils-ping \
  net-tools \
  dnsutils \
  zip unzip \
  curl \
  fonts-noto-cjk fonts-noto-cjk-extra \
  apt install rabbitvcs-nautilus \
  gimp-plugin-registry gmic gimp-gmic inkscape dia \
  git \
  && curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add - \
  && echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list \
  && apt update && apt install dbeaver-ce \
  && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
  && install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings \
  && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
  && apt update && apt -y install apt-transport-https \
  && apt update && apt -y install code \
  && sed -i -e "s|certificate=|certificate=/etc/letsencrypt/live/mysv986.com/cert.pem|g" /etc/xrdp/xrdp.ini \
  && sed -i -e "s|key_file=|key_file=/etc/letsencrypt/live/mysv986.com/privkey.pem|g" /etc/xrdp/xrdp.ini \
  && echo '[supervisord]' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'nodaemon=true' >> /etc/supervisor/conf.d/sv.conf \
  && echo '[program:xrdp-sesman]' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'command=/usr/sbin/xrdp-sesman -nodaemon' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'autostart=true' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'autorestart=true' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'priority=100' >> /etc/supervisor/conf.d/sv.conf \
  && echo '[program:xrdp]' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'command=/usr/sbin/xrdp -nodaemon' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'autostart=true' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'autorestart=true' >> /etc/supervisor/conf.d/sv.conf \
  && echo 'priority=200' >> /etc/supervisor/conf.d/sv.conf \
  && groupadd -g 1000 admin \
  && useradd -d /home/admin -m -s /bin/bash -u 1000 -g 1000 admin \
  && echo 'admin:admin' | chpasswd \
  && echo "admin ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak \
  && apt clean && apt autoremove \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo

CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
