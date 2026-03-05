FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create openfang user and directories
RUN useradd -r -s /bin/false openfang && \
    mkdir -p /home/openfang/.openfang/data && \
    chown -R openfang:openfang /home/openfang

WORKDIR /home/openfang

# Download and install OpenFang binary
RUN curl -fsSL https://github.com/RightNow-AI/openfang/releases/download/v0.3.23/openfang-x86_64-unknown-linux-gnu.tar.gz \
    | tar xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/openfang

# Copy config
COPY --chown=openfang:openfang config.toml /home/openfang/.openfang/config.toml

# Switch to non-root user
USER openfang

# Set environment variables
ENV OPENFANG_LISTEN=0.0.0.0:4200
ENV OPENFANG_HOME=/home/openfang/.openfang

EXPOSE 4200

CMD ["openfang", "start"]
