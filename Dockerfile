FROM debian:11 AS builder

RUN apt-get update && apt-get install -y \
  libicu-dev \
  python \
  ruby \
  bison \
  flex \
  cmake \
  build-essential \
  ninja-build \
  git \
  gperf

WORKDIR /workspaces

RUN git clone --depth=1 https://github.com/WebKit/webkit.git WebKit

RUN cd ./WebKit \
  && Tools/Scripts/build-webkit --jsc-only --cmakeargs="-DENABLE_STATIC_JSC=ON -DUSE_THIN_ARCHIVES=OFF"


FROM debian:12-slim

RUN apt-get update && apt-get install -y \
  libicu-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /workspaces/WebKit/WebKitBuild/Release/bin/jsc /usr/local/bin/

ENTRYPOINT [ "jsc" ]
