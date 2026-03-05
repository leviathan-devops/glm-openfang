FROM rust:1.83-bookworm AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
COPY . .
RUN cargo install --path crates/openfang-cli

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/openfang /usr/local/bin/openfang
COPY agents /opt/openfang/agents
COPY prompts /opt/openfang/prompts
COPY config.toml /opt/openfang/config.toml

ENV OPENFANG_HOME=/data
ENV PORT=8080
WORKDIR /opt/openfang
EXPOSE 8080
CMD ["openfang", "start", "--config", "config.toml"]
