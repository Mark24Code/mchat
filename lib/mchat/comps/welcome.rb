module Mchat
  module Welcome
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
    content.style.jade
    end
  end
end
