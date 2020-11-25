FROM ubuntu:20.04 AS lein-base

ARG LEIN_VERSION
ARG LEIN_SOURCE='https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'
ARG LEIN_STANDALONE="https://github.com/technomancy/leiningen/releases/download/${LEIN_VERSION}/leiningen-${LEIN_VERSION}-standalone.zip"

RUN apt update &&                     \
  apt install -y curl
RUN curl -fSsL -O "${LEIN_SOURCE}" && \
  mv lein /usr/bin &&                 \
  chmod a+x /usr/bin/lein

RUN mkdir /usr/local/share/lein && \
  curl -L "${LEIN_STANDALONE}" > "/usr/local/share/lein/leiningen-${LEIN_VERSION}-standalone.jar"

FROM runejuhl/graalvm:latest AS graal-base

ARG LEIN_VERSION
LABEL maintainer='Rune Juhl Jacobsen <runejuhl@enableit.dk>'
LABEL version=$LEIN_VERSION

ENV LEIN_JAR=/usr/local/share/lein/leiningen-${LEIN_VERSION}-standalone.jar
ENV LEIN_HOME=/usr/local/share/lein

COPY --from=lein-base /usr/bin/lein /usr/bin/lein

RUN mkdir -p /usr/local/share/lein/self-installs
COPY --from=lein-base /usr/local/share/lein/ /usr/local/share/lein/self-installs/
