FROM sshnaidm/docker-ilo-client AS base

RUN apt-get install -y xterm

ADD ./set-firefox-proxy.sh /usr/local/bin/
ADD ./.xinitrc /root/

# RUN /usr/local/bin/set-firefox-proxy.sh localhost 9945

# ENTRYPOINT ["/userscript.sh"]
ENTRYPOINT ["/usr/local/bin/set-firefox-proxy.sh"]
