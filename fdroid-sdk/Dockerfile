FROM ubuntu:bionic
MAINTAINER Rune Juhl Jacobsen <runejuhl@petardo.dk>

# Copied from https://hub.docker.com/r/cgeo/fdroid-base/dockerfile

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

VOLUME ["/apk/repo"]
WORKDIR /apk

# Enable i386 arch (for android SDK)
RUN dpkg --add-architecture i386 \
  && apt-get -qq update \
  && apt-get install -q -y \
       software-properties-common \
  && add-apt-repository -y ppa:guardianproject/ppa \
  && apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
       apksigner \
       curl \
       fdroidserver \
       git \
       libffi-dev \
       libjpeg62-dev \
       libssl-dev \
       libstdc++6:i386 \
       openjdk-8-jdk \
       python3-dev \
       python3-pip \
       python3-pyasn1 \
       wget \
       zlib1g-dev \
       zlib1g:i386 \
  && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install pillow --no-cache-dir \
  && mkdir $ANDROID_HOME \
  && curl -L https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar xzf - -C $ANDROID_HOME --strip-components=1 \
  && echo "y" | android update sdk --all --no-ui --force --filter build-tools-24.0.1,platform-tools,tools

RUN git clone --depth 1 https://gitlab.com/fdroid/fdroidserver.git /opt/fdroidserver \
  && cd /opt/fdroidserver                                                            \
  && pip3 install --no-binary python-vagrant -e .                                    \
  && python3 setup.py compile_catalog build                                          \
  && python3 setup.py install \
  && ln -sf /opt/fdroidserver/fdroid /usr/local/bin/fdroid

