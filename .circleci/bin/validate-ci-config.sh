#!/usr/bin/env bash
set -euo pipefail
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のエラーを検出

#
# circleciのconfigを検証
#
# 引数
# 1. 検証するファイルパス(default: config.yml)
#
export CIRCLECI_CLI_TELEMETRY_OPTOUT=true
readonly DEFAULT_CONFIG='config.yml'
readonly config_path=${1:-${DEFAULT_CONFIG}}

# バージョン確認
echo 'バージョン確認'
circleci --version

# 構文チェック
circleci --skip-update-check config validate "${config_path}"
