FROM ubuntu:20.04 AS build

ARG GRAALVM_VERSION
ENV GRAALVM_VERSION=$GRAALVM_VERSION
ARG GRAALVM_RELEASE
ENV GRAALVM_RELEASE=$GRAALVM_RELEASE
ARG DOWNLOAD_URL
ENV PATH /usr/local/graalvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update &&                          \
    apt-get install --no-install-recommends -y \
            curl                               \
            openjdk-11-jre-headless

RUN curl -L "${DOWNLOAD_URL}" | \
      tar zx -C /usr/local/ &&  \
      ln -s /usr/local/graalvm-${GRAALVM_RELEASE}-${GRAALVM_VERSION} /usr/local/graalvm

RUN cp /usr/lib/jvm/java-11-openjdk-amd64/lib/security/cacerts /usr/local/graalvm/lib/security/cacerts

FROM ubuntu:20.04

ARG VERSION
LABEL maintainer='Rune Juhl Jacobsen <runejuhl@enableit.dk>'
LABEL version=${VERSION}

COPY --from=build /usr/local/graalvm /usr/local/graalvm

ADD Dockerfile /
ENV JAVA_HOME /usr/local/graalvm
ENV PATH /usr/local/graalvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gu install native-image

RUN apt-get update &&                                                   \
  apt-get install --no-install-recommends -y gcc git make zlib1g-dev && \
  apt-get autoclean &&                                                  \
  apt-get autoremove &&                                                 \
  rm -rf /var/cache/apt /var/lib/apt/lists

ENV GRAALVM_HOME /usr/local/graalvm

CMD java -version
