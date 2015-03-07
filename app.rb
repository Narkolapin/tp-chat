require 'sinatra/base'

module ChatDemo
  class App < Sinatra::Base

    set :sessions, true

    get "/" do
      erb :"login.html"
    end

    post '/login' do
      session['utilisateur'] = params['user']
      session['motdepass'] = params['pwd']
      response.set_cookie(session['utilisateur'],settings.token) 
      redirect '/'
    end

    get "/chat" do
      user = session['utilisateur']
      erb :"chat.html"
    end
  end
end