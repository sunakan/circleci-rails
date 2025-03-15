# frozen_string_literal: true

# ApplicationRecordは、全てのModelクラスの基底クラス
# rails newした時に自動で作られるクラス
# 共通の設定やデフォルト値を定義
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
