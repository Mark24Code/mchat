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
        if _current_nickname
          resp = ::Mchat::Api.leave_channel( _current_channel , _current_nickname)
          code = resp.fetch("code")
          if code == StatusCode::Success
            puts "#{_current_nickname} leave success.".style.primary
            _current_nickname = nil
          else
            puts "leave request connect fail. try again.".style.warn
          end
        else
          puts "You are not have name in channel. Not need leave.".style.warn
        end
      end

    end
  end
end