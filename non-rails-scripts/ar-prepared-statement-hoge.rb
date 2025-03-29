require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: 'db',
  username: 'root',
  database: 'circleci_rails_development'
)

# プリペアドステートメントを使用したクエリ
sql = 'SELECT * FROM users WHERE name LIKE ?'

# ActiveRecordのexecuteメソッドでプリペアドステートメントを実行
ActiveRecord::Base.connection.execute("PREPARE stmt FROM 'SELECT * FROM users WHERE name = ?'")
ActiveRecord::Base.connection.execute("SET @name = 'John'")
ActiveRecord::Base.connection.execute("EXECUTE stmt USING @name")
ActiveRecord::Base.connection.execute("SET @name = '太郎'")
ActiveRecord::Base.connection.execute("EXECUTE stmt USING @name")
ActiveRecord::Base.connection.execute("PREPARE stmt2 FROM 'SELECT * FROM users WHERE name = ?'")
ActiveRecord::Base.connection.execute("SET @name = 'Dan'")
ActiveRecord::Base.connection.execute("EXECUTE stmt2 USING @name")
