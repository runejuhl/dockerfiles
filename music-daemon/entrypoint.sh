#!/bin/bash

MDNS_HOSTNAME=${MDNS_HOSTNAME:-${SERVER_NAME}}

if [[ "${ENABLE_AVAHI}" -eq 1 ]]; then
  sed -ri \
      -e "s@^#*(host-name=).*@\\1${MDNS_HOSTNAME}@g" \
      -e "s@^#*(domain-name=).*@\\1${AVAHI_DOMAIN_NAME}@g" \
      -e "s@^#*(enable-dbus=).*@\\1no@g" \
      /etc/avahi/avahi-daemon.conf

  /usr/sbin/avahi-daemon --no-rlimits &
fi

sed -ri \
    -e "s@^( *format *)\".+\"\$@\\1\"${SAMPLE_FORMAT}\"@g" \
    /etc/mpd.conf

mpd --stderr

snapserver --port "${SNAPSERVER_PORT}" \
           --controlPort "${SNAPSERVER_CONTROL_PORT}" \
           --sampleformat "${SAMPLE_FORMAT}"
