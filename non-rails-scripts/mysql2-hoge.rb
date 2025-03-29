require 'mysql2'
# Gemfileに記述が必須
#require 'mysql2-cs-bind'

client = Mysql2::Client.new(
  host: 'db',
  username: 'root',
  database: 'circleci_rails_development'
)

sql = 'SELECT * FROM users WHERE name = ?'
# mysql2
stmt = client.prepare(sql)
stmt.execute('John')
# mysql2-cs-bind
#client.xquery(sql, 'John')
