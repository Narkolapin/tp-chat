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

    get "/chat" do
      erb :"chat.html", :locals => {:user => session['utilisateur']}
    end
  end
end