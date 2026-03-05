# syntax=docker/dockerfile:1
FROM rust:1-slim-bookworm AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY xtask ./xtask
COPY agents ./agents
COPY packages ./packages
RUN cargo build --release --bin openfang

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/release/openfang /usr/local/bin/
COPY --from=builder /build/agents /opt/openfang/agents
COPY --from=builder /build/prompts /opt/openfang/prompts
COPY config.toml /opt/openfang/config.toml

# Railway provides PORT environment variable
EXPOSE 8080
VOLUME /data
ENV OPENFANG_HOME=/data
WORKDIR /opt/openfang
CMD ["openfang", "start", "--config", "config.toml"]
