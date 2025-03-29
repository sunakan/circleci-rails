require 'mysql2-cs-bind'

client = Mysql2::Client.new(
  host: 'db',
  username: 'root',
  database: 'circleci_rails_development'
)

sql = 'SELECT * FROM users WHERE name = ?'
client.xquery(sql, 'John')
client.xquery(sql, '太郎')
client.xquery(sql, 'Dan')
