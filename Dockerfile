FROM ghcr.io/rightnow-ai/openfang:latest

ENV OPENFANG_HOME=/data

WORKDIR /app

# Create config directory
RUN mkdir -p /root/.openfang/agents/shark-commander /root/.openfang/prompts /data

# Copy config files
COPY config.toml /root/.openfang/config.toml
COPY agents/shark-commander/agent.toml /root/.openfang/agents/shark-commander/agent.toml
COPY prompts/shark-commander.md /root/.openfang/prompts/shark-commander.md

EXPOSE 4200

CMD ["openfang", "start"]
