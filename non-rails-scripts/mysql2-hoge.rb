require 'mysql2'

client = Mysql2::Client.new(
  host: 'db',
  username: 'root',
  database: 'circleci_rails_development'
)

sql = 'SELECT * FROM users WHERE name = ?'
stmt = client.prepare(sql)
stmt.execute('John')
stmt.execute('太郎')
client.prepare(sql).execute('Dan')
