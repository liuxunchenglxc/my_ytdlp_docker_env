FROM ghcr.io/denoland/deno:ubuntu

ARG ORG_NAME=yt-dlp
ARG REPO_NAME=yt-dlp
ARG FILE_NAME=yt-dlp_linux

# https://github.com/Brainicism/bgutil-ytdlp-pot-provider
ARG YT_POT_VERSION=1.3.1
ENV YT_POT_VERSION=$YT_POT_VERSION

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
    software-properties-common \
    ffmpeg \
    curl \
    wget \
    git \
    aria2 \
    ca-certificates \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y python3.13 \
    && rm -rf /var/lib/apt/lists/*

RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases | grep -m 1 "tag_name" | cut -d'"' -f4) && \
    echo "最新版本是: ${LATEST_VERSION}" && \
    curl -L "https://github.com/${ORG_NAME}/${REPO_NAME}/releases/download/${LATEST_VERSION}/${FILE_NAME}" -o /usr/local/bin/${FILE_NAME} && \
    chmod a+rx /usr/local/bin/${FILE_NAME}

RUN wget https://bootstrap.pypa.io/get-pip.py \
    && ln -sf /usr/bin/python3.13 /usr/bin/python3 \
    && ln -sf /usr/bin/python3.13 /usr/bin/python \
    && python get-pip.py \
    && pip install --no-cache-dir requests \
    && rm get-pip.py

RUN git clone --depth 1 --single-branch --branch ${YT_POT_VERSION} https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git /bgutil-ytdlp-pot-provider \
    && cd /bgutil-ytdlp-pot-provider/server/ \
    deno install --allow-scripts=npm:canvas --frozen

RUN mkdir -p /etc/yt-dlp-plugins \
    && curl -L "https://github.com/Brainicism/bgutil-ytdlp-pot-provider/releases/download/${YT_POT_VERSION}/bgutil-ytdlp-pot-provider.zip" -o /etc/yt-dlp-plugins/bgutil-ytdlp-pot-provider.zip

WORKDIR /workspace