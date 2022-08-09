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
      Client::Api.
      puts Message.new({
        timestamp: Time.now.to_i,
        user_name: 'Mchat',
        content: 'Welcome use Mchat!'
      }).display
    end
  end
end