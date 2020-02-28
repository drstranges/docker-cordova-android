# docker-cordova-android
A minimal Docker image based on [Alpine Linux](https://hub.docker.com/_/alpine) with environment for building app with cordova for android

## Content &nbsp;/

- Alpine ( **3.11** )
- OpenJDK 8 ( **8u242** )
- Android SDK ( **8+ P, API 28, rev 6 (6200805)** )
- Android SDK Build-Tools ( **28.0.3** )
- Google Repository ( **latest** )
- Google Play Services ( **latest** )
- Android SDK Tools ( **latest** )
- Android SDK Platform-Tools ( **latest** )
- Android Support Repository ( **latest** )
- Quasar-CLI ( **latest** )
- Cordova ( **latest** )
- Cordova Andrroid Platform ( **latest** )
- add-ons: **bash, curl, git, openssl, openssh-client, ca-certificates, yarn, node**

## Usage

```Dockerfile
FROM drstranges/alpine-cordova-android
```

### or as pull from Docker Hub

```sh
$ docker pull drstranges/alpine-cordova-android
```

### or as local build

```sh
$ git clone https://github.com/drstranges/docker-cordova-android.git && cd docker-cordova-android 
$ docker build --no-cache -t drstranges/alpine-cordova-android .
```

### or as running container

```sh
$ docker run --rm -it drstranges/alpine-cordova-android
```

## License

Released under the [MIT License](#LICENSE).
