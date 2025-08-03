FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FORCE_UNSAFE_CONFIGURE=1

# Install environment
RUN apt-get update && apt-get install -y \
    build-essential clang flex bison g++ g++-multilib gcc-multilib \
    gawk gettext autopoint git libncurses-dev libncursesw5-dev libssl-dev \
    python3-distutils python3-dev python3-setuptools swig \
    rsync unzip zlib1g-dev file wget ca-certificates \
    xz-utils autoconf automake libtool pkg-config \
    texinfo m4 perl po4a \
    gperf help2man \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone openwrt
RUN git clone https://github.com/openwrt/openwrt.git

# Copy feed to docker image
COPY ./mypackages ./mypackages

WORKDIR /build/openwrt

# Add feed to config file
RUN echo "src-link mypackages /build/mypackages" >> feeds.conf.default

# Update & install feed
RUN ./scripts/feeds update -a && ./scripts/feeds install -a

# Copy config file
COPY .config .config

# Merge dependency
RUN make defconfig

RUN make -j1 V=s tools/tar/compile

# Build 
RUN make -j$(nproc) 

# Copy image and file .apk to /output
RUN mkdir -p /output && \
    cp -r bin/targets/omap/generic/openwrt-omap-generic-ti_am335x-bone-black-ext4-sdcard.img.gz /output/ && \
    cp -r bin/packages/arm_cortex-a8_vfpv3/mypackages/check_python_version-1.0-r1.apk /output/

CMD cp -rf /output/* /output_volume
