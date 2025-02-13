FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG QBITTORRENT_VERSION
LABEL maintainer="guzmi"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# add repo and install qbitorrent
RUN \
 echo "***** add qbitorrent repositories ****" && \
 apt-get update && \
 apt-get install -y \
        gnupg \
        python3 \
	apt-transport-https ca-certificates \
	software-properties-common \
	python3-pip && \
#	python-setuptools && \
#	python-dev && \
 python3 -m pip install --upgrade pip && \
 python3 -m pip install --upgrade setuptools && \
 python3 -m pip install telegram python-telegram-bot --upgrade && \
 #curl -s https://bintray.com/user/downloadSubjectPublicKey?username=fedarovich | apt-key add - && \
 #apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 7CA69FC4 && \
 #echo "deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu bionic main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 #echo "deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu bionic main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 #echo "deb https://dl.bintray.com/fedarovich/qbittorrent-cli-debian bionic main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 #echo "**** install packages ****" && \
 #if [ -z ${QBITTORRENT_VERSION+x} ]; then \
 #       QBITTORRENT_VERSION=$(curl -sX GET http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu/dists/bionic/main/binary-amd64/Packages.gz | gunzip -c \
 #       |grep -A 7 -m 1 "Package: qbittorrent-nox" | awk -F ": " '/Version/{print $2;exit}');\
 #fi && \
 #apt-get update && \
 add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable && \
 curl -sL 'https://dl.cloudsmith.io/public/qbittorrent-cli/qbittorrent-cli/gpg.F8756541ADDA2B7D.key' | apt-key add - && \
 curl -sL https://repos.fedarovich.com/ubuntu/bionic/qbittorrent-cli.list > /etc/apt/sources.list.d/qbittorrent-cli.list && \
 apt-get update && \ 
 apt-get install -y \
        p7zip-full \
  #      qbittorrent-cli \
  #      qbittorrent-nox \
  #      qbittorrent-nox=${QBITTORRENT_VERSION} \
        qbittorrent-cli \
        qbittorrent-nox \
        unrar \
        geoip-bin \
        unzip \
	rclone && \
  #      curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
  #      unzip rclone-current-linux-amd64.zip && \
  #      cd rclone-*-linux-amd64 && \
  #      cp rclone /usr/bin/ && \
  #      chown root:root /usr/bin/rclone && \
  #      chmod 755 /usr/bin/rclone && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 6881 6881/udp 8085
VOLUME /config /downloads
