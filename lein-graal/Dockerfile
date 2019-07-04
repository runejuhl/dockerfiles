FROM ubuntu:18.04 AS lein-base

RUN apt update && \
  apt install -y curl
RUN curl -fSsL -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
  mv lein /usr/bin && \
  chmod a+x /usr/bin/lein

RUN mkdir /usr/local/share/lein && curl -L https://github.com/technomancy/leiningen/releases/download/2.9.1/leiningen-2.9.1-standalone.zip > /usr/local/share/lein/leiningen-2.9.1-standalone.jar

FROM runejuhl/graalvm:latest AS base

ENV LEIN_JAR=/usr/local/share/lein/leiningen-2.9.1-standalone.jar
ENV LEIN_HOME=/usr/local/share/lein

COPY --from=lein-base /usr/bin/lein /usr/bin/lein

RUN mkdir -p /usr/local/share/lein/self-installs
COPY --from=lein-base /usr/local/share/lein/ /usr/local/share/lein/self-installs/
