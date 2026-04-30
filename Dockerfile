FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    bash \
    openssh-client \
    ca-certificates \
    procps \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --production
RUN npm install -g @anthropic-ai/claude-code

COPY . .

RUN chmod +x scripts/*.sh

RUN mkdir -p /workspace /app/simulation-logs

EXPOSE 7860

ENV NODE_ENV=production
ENV PORT=7860
ENV VITE_IS_PLATFORM=true

CMD ["bash", "scripts/start.sh"]
