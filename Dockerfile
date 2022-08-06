FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update \
  && apt-get -y install vim task-japanese locales-all \
  && echo 'LC_ALL=ja_JP.UTF-8' > /etc/default/locale \
  && echo 'LANG=ja_JP.UTF-8' >> /etc/default/locale \
  && apt install -y task-lxde-desktop \
  xrdp \
  supervisor \
  task-japanese-desktop \
  tzdata \
  sudo \
  jwm \
  lxterminal \
  fonts-ipafont \
  fonts-ipafont-gothic \
  fonts-ipafont-mincho \
  dbus-x11 \
  fcitx-mozc \
  fcitx-imlist \
  vim-gtk3 \
  libcurl4 \
  epiphany-browser \
  curl \
  feh \
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
  && groupadd -g 1000 kuhara \
  && useradd -d /home/kuhara -m -s /bin/bash -u 1000 -g 1000 kuhara \
  && echo 'kuhara:kuhara' | chpasswd \
  && echo "kuhara ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak \
  && apt-get clean && apt-get autoremove \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# タイムゾーン
ENV TZ=Asia/Tokyo

CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
