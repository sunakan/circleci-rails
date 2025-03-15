# frozen_string_literal: true

source 'https://rubygems.org'

# rails
# Railsアプリ本体gem
gem 'rails', '~> 8.0.2'

# mysql2
# MySQLに接続するためのgem
gem 'mysql2', '~> 0.5'

# puma
# webサーバー(デファクト)
gem 'puma', '>= 5.0'

# solid_cable
# Rails 8でデフォルトのAction Cableアダプターとして導入されたGem
# Webソケットとリアルタイム更新を提供し、Redisなどの外部メッセージブローカーを必要とせずに、DBに直接メッセージを保存・取得
gem 'solid_cable'

# solid_cache
# RailsのキャッシュをDBに保存するためのGem
# RedisやMemcachedなどの外部キャッシュストアを使用せずに、DBをキャッシュストアとして利用
gem 'solid_cache'

# solid_queue
# DBをバックエンドに使用するActive Jobのキューイングバックエンド
# RedisやSidekiqなどの外部キューイングシステムを必要とせずに、DBを直接使用してジョブを管理
gem 'solid_queue'

# bootsnap
# Reduces boot times through caching; required in config/boot.rb
# RubyおよびRailsアプリの起動時間を短縮するためのGem
# 主にパススキャンとコンパイルキャッシュを最適化することで、起動時間を改善
# YAMLやJSONの読み込みもキャッシュ化する機能有り
# config/boot.rbに `require 'bootsnap/setup'` が必要
# 効果
# - 起動時間の短縮(例: Shopifyでは約75%短縮)
# - キャッシュディレクトリが書き込み可能である必要がある
gem 'bootsnap', require: false

# HTTPアセットのキャッシュと圧縮、X-SendfileアクセラレーションをPumaサーバーに追加するGem
# Webアプリケーションのパフォーマンスを向上
# thrusterはBasecampによって開発されていますが、詳細な情報は提供されていない
gem 'thruster', require: false

group :development do
  # rubocop
  # rubyのlinter
  # .rubocop.ymlにルールのON/OFF、細かい制御を記載
  # pluginでルール追加やプリセットも追加可能
  gem 'rubocop'

  # rubocop-performance
  # rubocopのパフォーマンス系の拡張
  # 主に `Performance/*` ルールが追加される
  gem 'rubocop-performance'

  # rubocop-rails
  # rubocopのrails系の拡張
  # 主に `Rails/*` ルールが追加される
  gem 'rubocop-rails'

  # rubocop-rspec
  # rubocopのrspecの拡張
  # 主に `RSpec/*` ルールが追加される
  gem 'rubocop-rspec'

  # rubocop-rspec_rails
  # rubocopのrails_rspecの拡張
  # 主に `RSpecRails/*` `が追加される
  gem 'rubocop-rspec_rails'
end

group :development, :test do
  # brakeman
  # Railsアプリケーションのセキュリティ脆弱性を静的解析で検出するためのGem
  gem 'brakeman', require: false

  # rspec-rails
  # RSpecをRailsアプリで使用するためのGem
  # RSpecはRubyのテストフレームワーク
  gem 'rspec-rails'
end
