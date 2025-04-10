# Just ubuntu22.04 with some basic and useful tools, like g++ git bazel tmux uv etc
## You can get from https://raw.githubusercontent.com/captainwc/.dotfiles/refs/heads/main/scripts/docker/dockerfile-dev-base
FROM dev-base:latest

WORKDIR /workspace

RUN apt update \
    && apt install -y --no-install-recommends \
    libjsoncpp-dev \
    ragel \
    libyaml-cpp-dev \
    libmysqlclient-dev \
    sqlite3 \
    libsqlite3-dev \
    redis-server \
    libevent-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libssl-dev \
    libtinyxml2-dev \
    libjemalloc-dev \
    libboost-dev \
    && git clone https://github.com/vipshop/hiredis-vip.git /tmp/hiredis-vip \
    && cd /tmp/hiredis-vip && make -j8 && make install && cd - \
    && sed -i '34i#include <stdlib.h>' /usr/local/include/hiredis-vip/adapters/libevent.h \
    && wget -O /tmp/zookeeper.zip https://shuaikai-bucket0001.oss-cn-shanghai.aliyuncs.com/pic_bed/2025_4/zookeeper-client-c-3.10.0-ubuntu22.zip \
    && cd /tmp && unzip zookeeper.zip && mkdir /usr/local/include/zookeeper && mv zookeeper/include/* /usr/local/include/zookeeper/ && mv zookeeper/lib/* /usr/local/lib/ && cd - \
    && ln -sf /usr/local/lib/libzookeeper_st.so.2.0.0 /usr/local/lib/libzookeeper_st.so \
    && ln -sf /usr/local/lib/libzookeeper_st.so.2.0.0 /usr/local/lib/libzookeeper_st.so.2 \
    && ln -sf /usr/local/lib/libzookeeper_mt.so.2.0.0 /usr/local/lib/libzookeeper_mt.so \
    && ln -sf /usr/local/lib/libzookeeper_mt.so.2.0.0 /usr/local/lib/libzookeeper_mt.so.2 \
    && ln -sf /usr/lib/x86_64-linux-gnu/libmysqlclient.so.21.2.41 /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so \
    && git clone https://github.com/captainwc/sylar.git \
    && apt clean && rm -rf /var/lib/apt/lists/*  /tmp/*

WORKDIR /workspace/sylar
CMD [ "/bin/bash" ]

## Build images:
# docker build -t sylar-dev .
## Start Container:
# docker run -it --rm sylar-dev-latest:latest
## First Time Build project
# make && make
