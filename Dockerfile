FROM alpine:3.11

# Setup ENV

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    JAVA_VERSION=8u242 \
    JAVA_ALPINE_VERSION=8.242.08-r0 \
    VERSION_SDK_TOOLS=6200805 \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    CORDOVA_VERSION=9.0.0 \
    CORDOVA_ANDROID_VERSION=8.1.0

ENV PATH=$PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools \
    LANG=C.UTF-8

ENV 

# Install jdk, bash, curl, git, openssl

RUN mkdir -p $ANDROID_HOME && \
    chown -R root.root $ANDROID_HOME && \

RUN apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" && \
apk add --no-cache bash curl git openssl openssh-client ca-certificates

# Install android-sdk

RUN wget -q -O sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-$VERSION_SDK_TOOLS_latest.zip && \
unzip sdk.zip -d $ANDROID_HOME && \
rm -f sdk.zip

# Install and update Android packages

ADD packages.txt $ANDROID_HOME

RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg && \

sdkmanager --update && yes | sdkmanager --licenses && \
sdkmanager --package_file=$ANDROID_HOME/android-packages.txt

# Install cordova

RUN apk add --no-cache nodejs npm yarn \
    && npm install --global cordova@${CORDOVA_VERSION} \
    && cordova telemetry off \
    && npm cache clean \
    && cordova -v

# Cache Cordova Android platform & build tools
RUN cordova create /tmp/dummy dummy.app DummyApp \
    && cd /tmp/cordovacache \
    && cordova platform add android@${CORDOVA_ANDROID_VERSION} \
    && cordova build android \
    && rm -rf /tmp/dummy

# Install quasar-cli
RUN yarn global add @quasar/cli
