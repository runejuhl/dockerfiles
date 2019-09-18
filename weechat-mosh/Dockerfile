FROM jkaberg/weechat AS build

ARG VERSION
LABEL maintainer='Rune Juhl Jacobsen <runejuhl@enableit.dk>'
LABEL version=$VERSION

RUN apk update && \
  apk add bash mosh-server openssh-server tmux

ENV USER_SHELL=/bin/bash
ADD Dockerfile /
ADD entrypoint.sh /
ADD rootfs/etc/ssh/sshd_config /etc/ssh/
ADD rootfs/etc/profile.d/tmux-attach.sh /etc/profile.d/

ENTRYPOINT ["/entrypoint.sh"]
