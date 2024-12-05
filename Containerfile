FROM debian:12

RUN apt update && apt install -y cmake clang bison flex xz-utils libfuse-dev libudev-dev pkg-config libc6-dev-i386 libcap2-bin git git-lfs libglu1-mesa-dev libcairo2-dev libgl1-mesa-dev libtiff5-dev libfreetype6-dev libxml2-dev libegl1-mesa-dev libfontconfig1-dev libbsd-dev libxrandr-dev libxcursor-dev libgif-dev libpulse-dev libavformat-dev libavcodec-dev libswresample-dev libdbus-1-dev libxkbfile-dev libssl-dev llvm-dev

RUN git lfs install

RUN GIT_CLONE_PROTECTION_ACTIVE=false git clone --recursive https://github.com/darlinghq/darling.git /tmp/darling
RUN mkdir /tmp/darling/build
WORKDIR /tmp/darling/build
RUN cmake ..
RUN make -j$(nproc)
RUN make install

WORKDIR /
RUN rm -rf /tmp/darling

ENV HOME=/Users/macuser
ADD shell /usr/bin
