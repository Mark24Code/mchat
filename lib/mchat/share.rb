require_relative './api'
module Mchat
  module Share
    def welcome(switch)
      if switch
        display_ascii_art
      end
    end

    def display_ascii_art
      # https://rubygems.org/gems/artii
puts <<-'EOF'
  __  __      _           _
 |  \/  |    | |         | |
 | \  / | ___| |__   __ _| |_
 | |\/| |/ __| '_ \ / _` | __|
 | |  | | (__| | | | (_| | |_
 |_|  |_|\___|_| |_|\__,_|\__|
                    
EOF
      resp = ::Client::Api.conn_server_startup
      startup_msg = JSON.parse(resp.body).fetch("data")
      puts Message.new(startup_msg).display
    end
  end
end