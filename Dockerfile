ARG javaVersion=8u242
ARG javaAlphineVersion=8.242.08-r0
ARG androidSdkTools=commandlinetools-linux-6200805_latest.zip
ARG glibcVersion=2.29-r0
ARG VCS_REF="git rev-parse --short HEAD"

FROM node:13.8.0-alpine3.11 as quasar

RUN apk add --no-cache npm yarn \
    && npm install --g cordova \
    && cordova telemetry off \
    && cordova -v \
    && npm install -g @quasar/cli

# =======================================================================================

FROM quasar as quasar-android

ARG javaVersion
ARG javaAlphineVersion
ARG androidSdkTools
ARG glibcVersion
ARG VCS_REF

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    JAVA_VERSION=${javaVersion} \
    JAVA_ALPINE_VERSION=${javaAlphineVersion} \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_CMD_TOOLS_HOME=/opt/android-sdk/cmdline-tools

ENV PATH=$PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_CMD_TOOLS_HOME/tools/bin

ADD android-packages.txt /home

RUN echo "Installing openjdk8..." \
    && apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" git \
    && apk add --no-cache --virtual=.build-dependencies wget ca-certificates \
    && echo "Installing glibc..." \
    && wget https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${glibcVersion}/glibc-${glibcVersion}.apk -O /tmp/glibc.apk \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${glibcVersion}/glibc-bin-${glibcVersion}.apk -O /tmp/glibc-bin.apk \
    && apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk \
    && rm "/etc/apk/keys/sgerrand.rsa.pub" "/tmp/glibc.apk" "/tmp/glibc-bin.apk" \
    && echo "Installing android-build-tools..." \
    && mkdir -p $ANDROID_SDK_ROOT \
    && mkdir -p $ANDROID_SDK_CMD_TOOLS_HOME \
    && mkdir -p $HOME/.android \
    && touch $HOME/.android/repositories.cfg \
    && wget -q -O sdk.zip https://dl.google.com/android/repository/${androidSdkTools} \
    && unzip sdk.zip -d $ANDROID_SDK_CMD_TOOLS_HOME \
    && rm -f sdk.zip \
    && echo "Accepting all licenses..." \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager --package_file=/home/android-packages.txt \
    && rm "/root/.wget-hsts" \
    && apk del .build-dependencies

    LABEL org.label-schema.vcs-ref=${VCS_REF} \
          org.label-schema.vcs-url="e.g. https://github.com/microscaling/microscaling"

ENTRYPOINT ["/bin/sh"]

