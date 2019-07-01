FROM ubuntu AS lein-base

RUN apt update && apt install -y curl
RUN curl -fSsL -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
  mv lein /usr/bin && \
  chmod a+x /usr/bin/lein

FROM runejuhl/graalvm:19.0.2 AS base

COPY --from=lein-base /usr/bin/lein /usr/bin/lein
