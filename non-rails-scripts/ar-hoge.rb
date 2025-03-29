require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: 'db',
  username: 'root',
  database: 'circleci_rails_development'
)

# Userモデル定義
class User < ActiveRecord::Base
end

# クエリ実行(loadで即時実行)
User.where('name LIKE ?', 'John').load
User.where('name LIKE ?', '太郎').load
User.where('name LIKE ?', 'Dan').load
