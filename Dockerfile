FROM rust:1-alpine AS base
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN apk update && \
    apk add --no-cache 7zip openssh git build-base musl-dev openssl openssl-dev perl protobuf-dev && \
    mkdir -p ~/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
WORKDIR /usr/src/app

# ----------------------------------------
FROM base AS dev
RUN apk update && \
    apk add --no-cache bash docker-cli && \
    rustup component add clippy

FROM base AS build

COPY . .
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/src/app/target \
    cargo build && cp target/debug/downlowd .
