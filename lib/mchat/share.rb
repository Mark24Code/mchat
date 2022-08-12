require_relative './api'
require_relative './message'
module MiniChat
  module Share
    def welcome(switch)
      if switch
        display_ascii_art
      end
    end

    def conn_server
      resp = ::MiniChat::Api.conn_server_startup
      startup_msg = JSON.parse(resp.body).fetch("data")
      return Message.new(startup_msg).display
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
    end
  end
end