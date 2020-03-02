ARG javaVersion=8u242
ARG javaAlphineVersion=8.242.08-r0
ARG androidSdkTools=commandlinetools-linux-6200805_latest.zip
# ARG gradleVersion=5.4.1
# ARG gradleZip=gradle-5.4.1-bin.zip
# ARG gradleWorkDir=/home/gradle

FROM alpine:3.11 as base
# Setup base tools

ARG javaVersion
ARG javaAlphineVersion
# ARG gradleWorkDir
# ARG gradleVersion

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    JAVA_VERSION=${javaVersion} \
    JAVA_ALPINE_VERSION=${javaAlphineVersion} \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_CMD_TOOLS_HOME=/opt/android-sdk/cmdline-tools \
    GRADLE_USER_HOME=/gradle

#    GRADLE_VERSION=${gradleVersion} \
#    GRADLE_HOME=${gradleWorkDir}/gradle-${gradleVersion} \
#    GRADLE_USER_HOME=/gradle

ENV PATH=$PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_CMD_TOOLS_HOME:$ANDROID_SDK_CMD_TOOLS_HOME/tools/bin

# :$GRADLE_HOME:$GRADLE_HOME/bin:$GRADLE_USER_HOME

RUN mkdir -p $ANDROID_SDK_ROOT \
    && mkdir -p $ANDROID_SDK_CMD_TOOLS_HOME \
    && apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" \
    && apk add --no-cache bash curl git openssl openssh-client ca-certificates

#    && mkdir -p $GRADLE_USER_HOME \
#    && mkdir -p $GRADLE_HOME


FROM base
# Install android-sdk and gradle

ARG androidSdkTools
# ARG gradleWorkDir
# ARG gradleZip
# ARG gradleVersion
#     && wget -q -O gradle.zip https://services.gradle.org/distributions/${gradleZip} \
#     && unzip gradle.zip -d ${gradleWorkDir} \
#     && rm -f gradle.zip \
#     && echo -ne "- with Gradle ${gradleVersion}\n" >> /root/.built

ADD android-packages.txt $ANDROID_SDK_ROOT

RUN mkdir -p $HOME/.gradle \
    && echo "org.gradle.daemon=false" >> $HOME/.gradle/gradle.properties \
    && echo "org.gradle.console=plain" >> $HOME/.gradle/gradle.properties \
    && apk add --no-cache gradle \
    && echo $ANDROID_SDK_ROOT && echo $ANDROID_SDK_CMD_TOOLS_HOME \
    && wget -q -O sdk.zip https://dl.google.com/android/repository/${androidSdkTools} \
    && unzip sdk.zip -d $ANDROID_SDK_CMD_TOOLS_HOME \
    && rm -f sdk.zip \
    && mkdir -p $HOME/.android \
    && touch $HOME/.android/repositories.cfg \
    && yes | sdkmanager --licenses > /dev/null \
    && sdkmanager --package_file=$ANDROID_SDK_ROOT/android-packages.txt

# Use this instead above to update packages if got error
# while read -r package; do PACKAGES="${PACKAGES}${package} "; done < $ANDROID_SDK_ROOT/android-packages.txt \
# && sdkmanager ${PACKAGES}


FROM base
# Install cordova && cache Cordova Android platform & build tools

RUN apk add --no-cache nodejs npm yarn \
    && npm install --global cordova \
    && cordova telemetry off \
    && cordova -v \
    && yarn global add @quasar/cli

#    && cordova create /tmp/dummy dummy.app DummyApp \
#    && cd /tmp/dummy \
#    && cordova platform add android \
#    && cordova build android \
#    && rm -rf /tmp/dummy

