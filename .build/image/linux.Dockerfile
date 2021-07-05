FROM lthn/build:lthn-compile-base as builder

WORKDIR /home/lthn/src

COPY . .

ENV USE_SINGLE_BUILDDIR=1
ARG NPROC=1

RUN set -ex && \
    git submodule init && git submodule update --depth 1 && \
    rm -rf chain/build && \
    if [ -z "$NPROC" ] ; \
        then make -j$(nproc) static ; \
        else make -j$NPROC static ; \
    fi && \
    (cd chain/build/release/bin && tar -cvzf linux-amd64.tar.gz *)

FROM alpine
COPY --from=builder /home/lthn/src/chain/build/release/bin/ /