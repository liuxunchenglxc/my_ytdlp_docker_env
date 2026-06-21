FROM ghcr.io/denoland/deno:ubuntu

ARG ORG_NAME=yt-dlp
ARG REPO_NAME=yt-dlp
ARG FILE_NAME=yt-dlp_linux
ARG LATEST_VERSION=$(curl -s https://api.github.com/repos/${ORG_NAME}/${REPO_NAME}/releases/latest | grep "tag_name" | cut -d'v' -f2 | cut -d'"' -f1)
ADD https://github.com/${ORG_NAME}/${REPO_NAME}/releases/download/v${LATEST_VERSION}/${FILE_NAME} /usr/local/bin/${FILE_NAME}

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
    python3 \
    python3-pip \
    ffmpeg \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /usr/local/bin/yt-dlp

RUN pip install --no-cache-dir requests

WORKDIR /workspace