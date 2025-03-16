#!/usr/bin/env sh
set -euo pipefail
#set -x
# -e: エラーが発生した時点でスクリプトを終了
# -u: 未定義の変数を使用した場合にエラーを発生
# -x: スクリプトの実行内容を表示(debugで利用)
# -o pipefail: パイプライン内のエラーを検出

#
# circleciのconfigを作成
#
export CIRCLECI_CLI_TELEMETRY_OPTOUT=true
readonly config_path='generated-config.yml'

echo 'circleciコマンドのバージョン確認'
circleci version

# configファイルを生成
circleci --skip-update-check config pack src/ > "${config_path}"

# 構文チェック
circleci --skip-update-check config validate "${config_path}"
