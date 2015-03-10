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

		#uri      = URI.parse(ENV["REDISCLOUD_URL"])
		#@redis   = Redis.new(host: uri.host, port: uri.port, password: uri.password)
		#Thread.new do
		#	redis_sub = Redis.new(host: uri.host, port: uri.port, password: uri.password)
		#	redis_sub.subscribe(CHANNEL) do |on|
		#	on.message do |channel, msg|
		#		@clients.each {|ws| ws.send(msg) }
		#end
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
				@clients.each {|client| client.send(event.data) }
				#@redis.publish(CHANNEL, event.data)				
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