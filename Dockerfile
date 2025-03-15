# syntax=docker/dockerfile:1
# check=error=true

# このDockrfileは本番環境用で、開発環境では使用しないでください
# Kaml or 手動ビルドを利用してください

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails-app

# ベースとなるパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl default-mysql-client libjemalloc2 libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 環境変数(本番環境用)
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# 最終的なイメージサイズを小さくするための中間ステージ
FROM base AS build

# gemに必要な最小限のパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# gemのインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリコードのcopy
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/




# 最終ステージ
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails-app/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]

#
# Note
#
# syntax=docker/dockerfile:1
# - Dockerfileの構文バージョンを指定
# - `docker/dockerfile:N`は、Dockerfile構文のバージョンNの最新リリースを使用を意味する
#
# check=error=true
# - ビルド時のチェックが警告ではなく、エラーになる
# - ビルド中に警告が発生するとビルドが失敗する
#
# BUNDLE_DEPLOYMENT
# Bundlerのデプロイモードの有効化・無効化
# - 1: 有効化
#   - Gemfile.lockとGemfileの不一致をチェック。これにより、依存関係の整合性を保つ
# - 0: 無効化(デフォルト: false)
#   - Gemfile.lockが更新されていない場合でも、Bundlerは警告やエラーを出さずにGemをインストール可能
#
# BUNDLE_PATH="/usr/local/bundle"
# - BundlerがGemをインストールするディレクトリを指定
#
# BUNDLE_WITHOUT="development"
# - Bundlerが特定のグループのGemをインストールしないように指定
# - ここでは「development」グループを指定
#
