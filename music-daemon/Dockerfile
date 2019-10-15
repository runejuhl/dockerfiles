FROM ubuntu:19.04 AS build

ENV SNAPCAST_VERSION=0.15.0
ENV SNAPCAST_DEB="snapserver_${SNAPCAST_VERSION}_amd64.deb"

RUN apt-get update && \
    apt-get install -y mpd curl

RUN curl -L -o "/tmp/${SNAPCAST_DEB}" "https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/${SNAPCAST_DEB}" && \
    dpkg -i "/tmp/${SNAPCAST_DEB}" && \
    rm -f "/tmp/${SNAPCAST_DEB}"
