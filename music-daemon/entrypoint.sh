#!/bin/bash

MDNS_HOSTNAME=${MDNS_HOSTNAME:-${SERVER_NAME}}

sed -ri \
    -e "s@^#*(host-name=).*@\\1${MDNS_HOSTNAME}@g" \
    -e "s@^#*(domain-name=).*@\\1${AVAHI_DOMAIN_NAME}@g" \
    -e "s@^#*(enable-dbus=).*@\\1no@g" \
    /etc/avahi/avahi-daemon.conf

# mkdir -p /var/run/dbus

# exec 3<> /run/dbus/address
# /usr/bin/dbus-daemon --system --print-address=3 --fork &

# sleep 1
# exec 3>&-

# ( echo -n "DBUS_SESSION_BUS_ADDRESS="; cat /run/dbus/address ) > /etc/profile.d/99-dbus.sh

/usr/sbin/avahi-daemon --no-rlimits &

sed -ri \
    -e "s@^( *format *)\".+\"\$@\\1\"${SAMPLE_FORMAT}\"@g" \
    /etc/mpd.conf

mpd --stderr

snapserver --port "${SNAPSERVER_PORT}" \
           --controlPort "${SNAPSERVER_CONTROL_PORT}" \
           --sampleformat "${SAMPLE_FORMAT}"

function test_dbus() {
  dbus-send --session                   \
            --dest=org.freedesktop.DBus \
            --type=method_call          \
            --print-reply               \
            /org/freedesktop/DBus       \
            org.freedesktop.DBus.ListNames
}
