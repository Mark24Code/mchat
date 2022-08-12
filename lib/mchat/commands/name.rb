module Mchat
  module Commands
    # Command Join
    module Name
      def command_name_help
        puts %Q(
             #{"Help: Name".style.bold}
command: /name <your name in channel>
explain: give your name in channel for chatting.
)
      end

      def command_name(user_name = nil)
        if @current_nickname
          puts "You have `name` and active in this channel now.".style.warn
          puts "Please leave this channel then change your name.".style.warn
        else
          resp = ::Mchat::Api.join_channel( @current_channel , user_name)
          code = resp.fetch("code")
          if code == StatusCode::Success
            puts "#{user_name} is avalibale.".style.primary
            @current_nickname = user_name
          else
            @current_nickname = nil
            puts "#{user_name} has been used in channel: #{@current_channel}\ntry rename.".style.warn
          end
        end
      end

    end
  end
end