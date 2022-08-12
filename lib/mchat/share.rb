require_relative './api'
require_relative './message'
module Mchat
  module Share
    def welcome(switch)
      if switch
        display_ascii_art
      end
    end

    def display_ascii_art
      # https://rubygems.org/gems/artii
content = <<-'EOF'
  __  __      _           _
 |  \/  |    | |         | |
 | \  / | ___| |__   __ _| |_
 | |\/| |/ __| '_ \ / _` | __|
 | |  | | (__| | | | (_| | |_
 |_|  |_|\___|_| |_|\__,_|\__|
                    
EOF
      resp = ::Client::Api.conn_server_startup
      startup_msg = JSON.parse(resp.body).fetch("data")
      return [content, Message.new(startup_msg).display]
    end
  end
end