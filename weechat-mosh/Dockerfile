FROM jkaberg/weechat AS build

ARG VERSION
LABEL maintainer='Rune Juhl Jacobsen <runejuhl@enableit.dk>'
LABEL version=$VERSION

RUN apk update && \
  apk add mosh-server
