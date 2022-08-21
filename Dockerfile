FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install vim less task-japanese locales-all \
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
  && sed -i -e "s|certificate=|certificate=/etc/letsencrypt/live/nodeexpressmongo.mysv986.com/cert.pem|g" /etc/xrdp/xrdp.ini \
  && sed -i -e "s|key_file=|key_file=/etc/letsencrypt/live/nodeexpressmongo.mysv986.com/privkey.pem|g" /etc/xrdp/xrdp.ini \
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

ENV TZ=Asia/Tokyo

CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
