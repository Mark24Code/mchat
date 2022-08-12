module Mchat
  module Commands
    # Command Join
    module Leave
      def command_leave_help
        puts %Q(
             #{"Help: Leave".style.bold}
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
            puts "#{@current_nickname} leave success.".style.primary
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


# module Mchat
#   class Command
#   end

#   class LeaveCommand
#     def initialize

#     end

#     def help
#         puts %Q(
# #{"Help: Leave".style.bold}
# command: /leave
# explain: leave channel and delete your name.
# )
#     end
#   end
# end