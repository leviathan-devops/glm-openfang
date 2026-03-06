FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/RightNow-AI/openfang/releases/download/v0.3.24/openfang-x86_64-unknown-linux-gnu.tar.gz | tar xz -C /usr/local/bin && chmod +x /usr/local/bin/openfang

RUN mkdir -p /root/.openfang

COPY config.toml /root/.openfang/config.toml

# Railway sets PORT dynamically - OpenFang reads OPENFANG_LISTEN
# Railway will override this with its PORT env var
ENV OPENFANG_LISTEN=0.0.0.0:4200

EXPOSE 4200

CMD ["/usr/local/bin/openfang", "start"]
