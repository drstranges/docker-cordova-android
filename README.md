# docker-cordova-android
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-info-blue.svg)](https://hub.docker.com/r/drstranges/alpine-cordova-android)
[![](https://images.microbadger.com/badges/image/drstranges/alpine-cordova-android.svg)](https://microbadger.com/images/drstranges/alpine-cordova-android)

A Docker image based on [Alpine Linux](https://hub.docker.com/_/alpine) with environment for building app with cordova for android

## Content &nbsp;/

- Alpine ( **3.11** )
- OpenJDK 8 ( **8u242** )
- Android SDK ( **8+ P, API 28, rev 6 (6200805)** )
- Android SDK Build-Tools ( **28.0.3** )
- Android SDK Platform-Tools ( **latest** )
- Quasar-CLI ( **latest** )
- Cordova ( **latest** )
- add-ons: **git, yarn, node**

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
