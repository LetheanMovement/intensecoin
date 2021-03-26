FROM ubuntu:16.04

ENV SRC_DIR /usr/local/src/lethean
# fix for gitlab
RUN apt-get update -qq && apt-get -qq --no-install-recommends install apt-utils

RUN set -x \
  && buildDeps=' \
      build-essential cmake pkg-config libboost-all-dev libssl-dev libzmq3-dev \
      libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev \
      libldns-dev libexpat1-dev doxygen graphviz libpgm-dev qttools5-dev-tools \
      libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev \
      ca-certificates git \
  ' \
  && apt-get -qq update \
  && apt-get -qq --no-install-recommends install $buildDeps

RUN git clone https://gitlab.com/lethean.io/blockchain/lethean.git $SRC_DIR
WORKDIR $SRC_DIR

# checkout is temporary until master is also xmr source
RUN make release-static

RUN cp build/release/bin/* /usr/local/bin/ \
  \
  && rm -r $SRC_DIR \
  && apt-get -qq --auto-remove purge $buildDeps

# Contains the blockchain
VOLUME /root/.lethean

# Generate your wallet via accessing the container and run:
# cd /wallet
# lethean-wallet-cli
VOLUME /wallet

ENV LOG_LEVEL 0
ENV P2P_BIND_IP 0.0.0.0
ENV P2P_BIND_PORT 48772
ENV RPC_BIND_IP 127.0.0.1
ENV RPC_BIND_PORT 48782

EXPOSE 48782
EXPOSE 48772

CMD letheand --log-level=$LOG_LEVEL --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC_BIND_PORT
