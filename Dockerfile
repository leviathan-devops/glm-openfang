FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Download pre-built OpenFang binary
RUN curl -fsSL https://github.com/RightNow-AI/openfang/releases/download/v0.3.23/openfang-x86_64-unknown-linux-gnu.tar.gz | tar xz -C /usr/local/bin

# Create config directory
RUN mkdir -p /root/.openfang

# Copy config
COPY config.toml /root/.openfang/config.toml

ENV OPENFANG_LISTEN=0.0.0.0:4200

EXPOSE 4200

CMD ["openfang", "start"]
