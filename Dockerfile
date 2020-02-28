ARG javaVersion=8u242
ARG javaAlphineVersion=8.242.08-r0
ARG androidSdkTools=commandlinetools-linux-6200805_latest.zip

FROM alpine:3.11 as base
# Setup base tools

ARG javaVersion
ARG javaAlphineVersion

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    JAVA_VERSION=${javaVersion} \
    JAVA_ALPINE_VERSION=${javaAlphineVersion} \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_CMD_TOOLS_HOME=/opt/android-sdk/cmdline-tools

ENV PATH=$PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_SDK_CMD_TOOLS_HOME:$ANDROID_SDK_CMD_TOOLS_HOME/tools/bin \
    LANG=C.UTF-8

RUN apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" \
    && apk add --no-cache bash curl git openssl openssh-client ca-certificates


FROM base
# Install android-sdk

ARG androidSdkTools

ADD android-packages.txt $ANDROID_HOME

RUN echo $ANDROID_HOME && echo $ANDROID_SDK_CMD_TOOLS_HOME \
    && mkdir -p $ANDROID_SDK_CMD_TOOLS_HOME \
    && wget -q -O sdk.zip https://dl.google.com/android/repository/${androidSdkTools} \
    && unzip sdk.zip -d $ANDROID_SDK_CMD_TOOLS_HOME \
    && rm -f sdk.zip \
    && mkdir -p $HOME/.android \
    && touch $HOME/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && sdkmanager --package_file=$ANDROID_HOME/android-packages.txt \
    && mkdir -p $HOME/.gradle \
    && echo "org.gradle.daemon=false" >> $HOME/.gradle/gradle.properties \
    && echo "org.gradle.console=plain" >> $HOME/.gradle/gradle.properties

# Use this instead above to update packages if got error
# while read -r package; do PACKAGES="${PACKAGES}${package} "; done < $ANDROID_HOME/android-packages.txt \
#   && sdkmanager ${PACKAGES}


FROM base
# Install cordova && cache Cordova Android platform & build tools

RUN apk add --no-cache nodejs npm yarn \
    && npm install --global cordova \
    && cordova telemetry off \
    && cordova -v \
    && cordova create /tmp/dummy dummy.app DummyApp \
    && cd /tmp/cordovacache \
    && cordova platform add android \
    && cordova build android \
    && rm -rf /tmp/dummy \
    && yarn global add @quasar/cli
