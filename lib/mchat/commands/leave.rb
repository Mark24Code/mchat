module Mchat
  module Commands
    # Command Join
    module Leave
      def command_leave_help
        puts %Q(
             #{bold("Help: Leave")}
command: /leave
explain: leave channel and delete your name.
)
      end

      def command_leave
        if @current_nickname
          resp = ::Mchat::Api.leave_channel( @current_channel , @current_nickname)
          data = JSON.parse(resp.body)
          code = data.fetch("code")
          if code == StatusCode::Success
            puts em("#{@current_nickname} leave success.")
            @current_nickname = nil
          else
            puts warn("leave request connect fail. try again.")
          end
        else
          puts warn("You are not have name in channel. Not need leave.")
        end
      end

    end
  end
end