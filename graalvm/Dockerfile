FROM ubuntu:18.04 AS build

ARG GRAALVM_VERSION=19.0.2
ENV PATH /usr/local/graalvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && \
    apt-get install -y \
            curl \
            openjdk-11-jre-headless

RUN curl -L "https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-linux-amd64-${GRAALVM_VERSION}.tar.gz" | \
      tar zx -C /usr/local/ && \
      rm -f /usr/local/graalvm-ce-${GRAALVM_VERSION}/src.zip && \
      ln -s /usr/local/graalvm-ce-${GRAALVM_VERSION} /usr/local/graalvm

RUN cp /usr/lib/jvm/java-11-openjdk-amd64/lib/security/cacerts /usr/local/graalvm/jre/lib/security/cacerts

FROM ubuntu:18.04

COPY --from=build /usr/local/graalvm /usr/local/graalvm

ADD Dockerfile /
ENV JAVA_HOME /usr/local/graalvm
ENV PATH /usr/local/graalvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gu install native-image

RUN apt-get update && \
  apt-get install -y gcc make zlib1g-dev && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/cache/apt /var/lib/apt/lists

ENV GRAALVM_HOME /usr/local/graalvm

CMD java -version
