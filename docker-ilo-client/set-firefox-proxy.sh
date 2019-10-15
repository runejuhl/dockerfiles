#!/bin/bash
#
# Based on https://stackoverflow.com/a/2518406

PROFILE=/config/.mozilla/firefox/6cw01mby.default
mkdir -p "${PROFILE}"

cat >> /config/.mozilla/firefox/profiles.ini <<EOF
[General]
StartWithLastProfile=1

[Profile0]
Name=default
Default=1
IsRelative=1
Path=6cw01mby.default
EOF

PREFS="${PROFILE}/prefs.js"
PROXY_TYPE=socks
PROXY_HOST="${1:-localhost}"
PROXY_PORT="${2:-9945}"

PREFS=/usr/lib/firefox/defaults/pref/syspref.js

cat >> "${PREFS}" <<EOF

pref("network.proxy.${PROXY_TYPE}", "'${PROXY_HOST}'")";
pref("network.proxy.${PROXY_TYPE}_port", ${PROXY_PORT});

pref("network.proxy.socks_version", 5);
pref("network.proxy.socks_remote_dns", true);

# Turn on the manual proxy configuration
pref("network.proxy.type", 1);
EOF

find "${PROFILE}"

/userscript.sh
