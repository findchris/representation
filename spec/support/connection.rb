ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", 
  :database => File.dirname(__FILE__) + "/representation.sqlite3"
)