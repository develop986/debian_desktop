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
  curl wget \
  gpg \
  fonts-noto-cjk fonts-noto-cjk-extra \
  rabbitvcs-nautilus \
  gimp-plugin-registry gmic gimp-gmic inkscape dia \
  git \
  && apt install -y software-properties-common apt-transport-https wget ca-certificates gnupg2 \
  && wget -O- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg \
  && echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list \
  && apt update && apt install -y google-chrome-stable \
  && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
  && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
  && sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' \
  && apt update && apt -y install apt-transport-https \
  && apt update && apt -y install code \
  && curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add - \
  && echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list \
  && apt update && apt install dbeaver-ce \
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
  && groupadd -g 1000 debian \
  && useradd -d /home/debian -m -s /bin/bash -u 1000 -g 1000 debian \
  && echo 'debian:debian' | chpasswd \
  && echo "debian ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak \
  && apt clean && apt autoremove \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo

CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
