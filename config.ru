require './app'
require './middlewares/chat_backend'

use TpChat::ChatBackend

run ChatDemo::App
