#!/usr/bin/env bash
set -euo pipefail
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のエラーを検出

#
# circleciのconfigを作成
#
# 引数
# 1. 出力するファイルパス(default: .circleci/config.yml)
#
readonly config_path=${1:-.circleci/config.yml}

# configファイルを生成
circleci --skip-update-check config pack .circleci/src > "${config_path}"

# 構文チェック
circleci --skip-update-check config validate "${config_path}"
