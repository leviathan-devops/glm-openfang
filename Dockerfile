FROM rust:1.83-bookworm AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
COPY . .
RUN cargo install --path crates/openfang-cli

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/openfang /usr/local/bin/openfang

# Create OpenFang home directory
RUN mkdir -p /root/.openfang/agents/shark-commander /root/.openfang/prompts /data

# Copy config files
COPY config.toml /root/.openfang/config.toml
COPY agents/shark-commander/agent.toml /root/.openfang/agents/shark-commander/agent.toml
COPY prompts/shark-commander.md /root/.openfang/prompts/shark-commander.md

ENV OPENFANG_HOME=/data
EXPOSE 4200
CMD ["openfang", "start"]
