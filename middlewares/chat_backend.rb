require 'faye/websocket'
require 'mongo'

module TpChat
  
  class ChatBackend
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL = "channel01"

    def initialize(app)
      @app     = app
      @clients = []
      mongo_client = MongoClient.new("mongodb://adrix:adrix@ds051851.mongolab.com:51851/chat")
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
				#message = {"message" => event.data} 
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