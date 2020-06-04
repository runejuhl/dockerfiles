FROM ubuntu:20.04 AS build

ENV SNAPCAST_VERSION=0.19.0
ENV SNAPCAST_DEB="snapserver_${SNAPCAST_VERSION}-1_amd64.deb"

RUN apt-get update && \
    apt-get install -y mpd curl

RUN curl -L -o "/tmp/${SNAPCAST_DEB}" "https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/${SNAPCAST_DEB}" && \
    dpkg -i "/tmp/${SNAPCAST_DEB}" && \
    rm -f "/tmp/${SNAPCAST_DEB}"

RUN apt-get install -y mpc iproute2

RUN apt-get install -y \
    avahi-daemon avahi-discover avahi-utils libnss-mdns moreutils

RUN rm -rf /var/cache/apt/*

ENV SNAPSERVER_PORT=1704
ENV SNAPSERVER_CONTROL_PORT=1705
ENV SAMPLE_FORMAT='48000:16:2'
ENV SERVER_NAME='music-daemon'
ENV AVAHI_DOMAIN_NAME='local'
ENV ENABLE_DBUS=1
ENV ENABLE_AVAHI=1

ADD ./etc/mpd.conf /etc/mpd.conf
ADD ./entrypoint.sh /

RUN mkdir /mpd /music /playlists

ADD Dockerfile /

ENTRYPOINT /entrypoint.sh
