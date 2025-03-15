# frozen_string_literal: true

# ApplicationMailerは、全てのMailerクラスの基底クラス
# rails newした時に自動で作られるクラス
# 共通の設定やデフォルト値を定義
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
