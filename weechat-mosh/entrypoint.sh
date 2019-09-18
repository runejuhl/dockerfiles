#!/bin/sh

# shellcheck disable=SC2039
usermod -o -u "$UID" weechat 2>/dev/null
groupmod -o -g "$GID" weechat 2>/dev/null

chown -R weechat:weechat /weechat

# Set the shell
if ! grep -qE "^weechat:.+?:${USER_SHELL}$" /etc/passwd; then
  sed -ri "s#^(weechat:.+?)/sbin/nologin#\\1${USER_SHELL}#" /etc/passwd
fi

# Generate SSH host keys if they don't already exist
ssh-keygen -A

/usr/sbin/sshd -E /var/log/sshd.log

# Ensure that the account is unlocked to allow SSH logins
if grep -qE '^weechat:!' /etc/shadow; then
  passwd=$(grep -Eo '[[:graph:]]' /dev/urandom | head -c 42 | tr -d \\n)
  printf "%s\\n%s" "${passwd}" "${passwd}" | passwd weechat 2>/dev/null
fi

exec su-exec weechat tmux new-session -s weechat "/usr/bin/weechat ${*}"
