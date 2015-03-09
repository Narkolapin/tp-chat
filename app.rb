require 'sinatra/base'

module ChatDemo
  class App < Sinatra::Base

    set :sessions, true

    post "/" do
      session[:utilisateur] = params['user']
      session[:motdepass] = params['pwd']
      redirect "/chat"
    end


    get "/" do
      erb :"login.html"
    end

    
    post "/chat" do
        user=params['user']
        text=params['text']

        db = URI("mongodb://adrix:adrix@ds051851.mongolab.com:51851/chat")
        db_name = db.path.gsub(/^\//, '')
        db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
        db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.password.nil?)

        db=db_connection['chat']
        coll=db['message']
        coll.insert([{:text => text}])
        
        redirect "/chat"
    end

    get "/chat" do
      erb :"chat.html", :locals => {:user => session['utilisateur']}
    end
  end
end