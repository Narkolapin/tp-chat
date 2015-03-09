require 'faye/websocket'
require 'mongo'
require 'uri'

module TpChat
  
  class ChatBackend
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL = "channel01"

    def initialize(app)
		@app     = app
		@clients = []

		db = URI("mongodb://adrix:adrix@ds051851.mongolab.com:51851/chat")
		db_name = db.path.gsub(/^\//, '')
		@db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
		@db_connection.authenticate(db.user, db.password)
		@db_connection
			

		connectdb = @db_connection
		db = connectdb["chat"]
		@coll = db["message"]
    end

    def call(env)
		if Faye::WebSocket.websocket?(env)
			
			#nouveau thread
			ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
			
			#Ouverture
			ws.on :open do |event|
				p [:open, ws.object_id]
				@clients << ws
			end
			
			#message
			ws.on :message do |event|
				p [:message, event.data]
				@coll.insert([{:content => message }])
				@clients.each {|client| client.send(event.data) }
				
			end
			
			#fermeture
			ws.on :close do |event|
				p [:close, ws.object_id, event.code, event.reason]
				@clients.delete(ws)
				ws = nil
			
			end
			ws.rack_response
		else
			@app.call(env)
		end
    end
  end

end