FROM mooxe/base:latest

MAINTAINER FooTearth "footearth@gmail.com"

WORKDIR /root

# system update
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get autoremove -y

RUN \
  apt-get install -y \
  make gcc \
  libreadline6 libreadline6-dev

ENV DOWNLOAD_PATH /root/downloads
RUN mkdir -p $DOWNLOAD_PATH

##########################################
# lua
##########################################
ENV LUA_VERSION 5.2.4
# ENV LUA_VERSION 5.3.1
ENV LUA_PATH lua-$LUA_VERSION
ENV LUA_FILE $LUA_PATH.tar.gz
RUN \

  curl -R \
    -o $DOWNLOAD_PATH/$LUA_FILE \
    "https://codeload.github.com/lua/lua/tar.gz/$LUA_VERSION" \

  && \

  tar xvf \
    $DOWNLOAD_PATH/$LUA_FILE \
    -C $DOWNLOAD_PATH

WORKDIR $DOWNLOAD_PATH/$LUA_PATH
RUN make linux && make install
WORKDIR /root
##########################################


##########################################
# lua jit
##########################################
ENV LUA_JIT_VERSION 2.0.4
ENV LUA_JIT_PATH LuaJIT-$LUA_JIT_VERSION
ENV LUA_JIT_FILE $LUA_JIT_PATH.tar.gz
RUN \

  curl -R \
    -o $DOWNLOAD_PATH/$LUA_JIT_FILE \
    "http://luajit.org/download/$LUA_JIT_FILE" \

  && \

  tar xvf \
    $DOWNLOAD_PATH/$LUA_JIT_FILE \
    -C $DOWNLOAD_PATH

WORKDIR $DOWNLOAD_PATH/$LUA_JIT_PATH
RUN make && make install
WORKDIR /root
##########################################


##########################################
# luarocks
##########################################
ENV LUAROCKS_VERSION 2.2.2
ENV LUAROCKS_PATH luarocks-$LUAROCKS_VERSION
ENV LUAROCKS_FILE $LUAROCKS_PATH.tar.gz
RUN \

  curl -fSL \
    -o $DOWNLOAD_PATH/$LUAROCKS_FILE \
    "http://luarocks.org/releases/$LUAROCKS_FILE" \

  && \

  tar xvf \
    $DOWNLOAD_PATH/$LUAROCKS_FILE \
    -C $DOWNLOAD_PATH

WORKDIR $DOWNLOAD_PATH/$LUAROCKS_PATH
# RUN ./configure && make bootstrap
RUN ./configure && make build && make install
WORKDIR /root
ENV BASH_PATH /root/.bashrc
ENV ZSH_PATH /root/.zshrc
ENV FISH_PATH /root/.config/fish/config.fish
RUN \
  eval `luarocks path` && \
  echo "export LUA_PATH='`echo $LUA_PATH`;./?.lua'" >> $BASH_PATH && \
  echo "export LUA_CPATH='`echo $LUA_CPATH`'" >> $BASH_PATH && \
  echo "export LUA_PATH='`echo $LUA_PATH`;./?.lua'" >> $ZSH_PATH && \
  echo "export LUA_CPATH='`echo $LUA_CPATH`'" >> $ZSH_PATH && \
  echo "set LUA_PATH '`echo $LUA_PATH`;./?.lua'" >>  $FISH_PATH && \
  echo "set LUA_CPATH '`echo $LUA_CPATH`'" >> $ZSH_PATH
##########################################


RUN rm -rf $DOWNLOAD_PATH
WORKDIR /root
