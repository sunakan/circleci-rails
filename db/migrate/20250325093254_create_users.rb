# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table(:users, comment: 'ユーザーテーブル') do |t|
      t.string(:name, comment: '名前')

      t.timestamps
    end
  end
end
