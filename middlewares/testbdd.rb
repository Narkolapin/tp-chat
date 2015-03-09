require 'mongo'
require 'uri'

def get_connection
  return @db_connection if @db_connection
  db = URI("mongodb://adrix:adrix@ds051851.mongolab.com:51851/chat")
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.password.nil?)
  @db_connection
end

connectdb = get_connection
db = connectdb["chat"]
coll = db["message"]

coll.insert([{:message => "hello 01"}])
coll.find{:message {|doc| puts doc.inspect} }
