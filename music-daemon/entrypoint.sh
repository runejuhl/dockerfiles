#!/bin/bash

function _ts() {
  ts "%H:%M:%S [${1}]"
}

MDNS_HOSTNAME=${MDNS_HOSTNAME:-${SERVER_NAME}}

enable_dbus_yesno=no

if [[ "${ENABLE_DBUS}" -eq 1 ]]; then
  enable_dbus_yesno=yes
  mkdir -p /run/dbus
  exec 3<> /run/dbus/address
  ( /usr/bin/dbus-daemon --system --print-address=3 --nosyslog |& _ts dbus-daemon ) &

  sleep 2
  exec 3>&-

  ( echo -n "DBUS_SESSION_BUS_ADDRESS="; cat /run/dbus/address ) > /etc/profile.d/99-dbus.sh

  set +a
  # shellcheck disable=SC1091
  . /etc/profile.d/99-dbus.sh
  set -a
fi

if [[ "${ENABLE_AVAHI}" -eq 1 ]]; then
  sed -ri \
      -e "s@^#*(host-name=).*@\\1${MDNS_HOSTNAME}@g" \
      -e "s@^#*(domain-name=).*@\\1${AVAHI_DOMAIN_NAME}@g" \
      -e "s@^#*(enable-dbus=).*@\\1${enable_dbus_yesno}@g" \
      /etc/avahi/avahi-daemon.conf

  ( /usr/sbin/avahi-daemon --no-drop-root \
                           --no-rlimits \
                           --debug |& _ts avahi-daemon ) &
fi

sed -ri \
    -e "s@^( *format *)\".+\"\$@\\1\"${SAMPLE_FORMAT}\"@g" \
    -e "s@^#*(zeroconf_enabled *)\".+\"\$@\\1\"${enable_dbus_yesno}\"@g" \
    /etc/mpd.conf

( mpd --stderr |& _ts mpd ) &

if [[ "${ENABLE_DBUS}" -eq 1 ]]; then
  cat <<EOF

For some reason dbus-daemon seems to hang for about 99 seconds right around here; be patient.

EOF
fi

( snapserver --port "${SNAPSERVER_PORT}" \
           --controlPort "${SNAPSERVER_CONTROL_PORT}" \
           --sampleformat "${SAMPLE_FORMAT}" |& _ts snapserver )
