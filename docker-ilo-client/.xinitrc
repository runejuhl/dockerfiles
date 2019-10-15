exec openbox-session &
xterm &
firefox ${HILO_HOST}/html/java_irc.html?sessionKey=$(cat /session_key)
