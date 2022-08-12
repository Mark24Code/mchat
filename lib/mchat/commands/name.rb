module Mchat
  module Commands
    # Command Join
    module Name
      def command_name_help
        puts %Q(
             #{bold("Help: Name")}
command: /name <your name in channel>
explain: give your name in channel for chatting.
)
      end

      def command_name(user_name = nil)
        if @current_nickname
          puts warn("You have `name` and active in this channel now.")
          puts warn("Please leave this channel then change your name.")
        else
          resp = ::Mchat::Api.join_channel( @current_channel , user_name)
          data = JSON.parse(resp.body)
          code = data.fetch("code")
          if code == StatusCode::Success
            puts em("#{user_name} is avalibale.")
            @current_nickname = user_name
          else
            @current_nickname = nil
            puts warn("#{user_name} has been used in channel: #{@current_channel}\ntry rename.")
          end
        end
      end

    end
  end
end