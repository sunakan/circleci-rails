# syntax=docker/dockerfile:1
# check=error=true

# このDockrfileはCI用です
FROM debian:bookworm-slim
ENV CIRCLECI_CLI_VERSION=0.1.31425
ENV CIRCLECI_CLI_TELEMETRY_OPTOUT=true

# ベースとなるパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends git unzip curl ca-certificates && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN curl -fsSL https://github.com/CircleCI-Public/circleci-cli/releases/download/v${CIRCLECI_CLI_VERSION}/circleci-cli_${CIRCLECI_CLI_VERSION}_linux_arm64.tar.gz | \
    tar -xzC /usr/local/bin circleci-cli_${CIRCLECI_CLI_VERSION}_linux_arm64/circleci --strip-components=1

RUN adduser ci
USER ci
