# This file is used by Rack-based servers to start the application.

#require ::File.expand_path('../config/environment',  __FILE__)
#run Rails.application


require './app/app'
require './middlewares/chat_backend'

use ChatDemo::ChatBackend

run ChatDemo::App
