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
        if @repl.current_nickname
          resp = ::Mchat::Api.leave_channel( @repl.current_channel , @repl.current_nickname)
          code = resp.fetch("code")
          if code == StatusCode::Success
            puts "#{@repl.current_nickname} leave success.".style.primary
            @repl.current_nickname = nil
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


module Mchat
  class Command
  end

  class LeaveCommand
    def initialize(repl)
      @repl = repl 
    end

    def help
%Q(
#{"Help: Leave".style.primary}
command: /leave
explain: leave channel and delete your name.

)
    end

    def command
      if @repl.current_nickname
        resp = ::Mchat::Api.leave_channel( @repl.current_channel , @repl.current_nickname)
        code = resp.fetch("code")
        if code == StatusCode::Success
          puts "#{@repl.current_nickname} leave success.".style.primary
          @repl.current_nickname = nil
        else
          puts "leave request connect fail. try again.".style.warn
        end
      else
        puts "You are not have name in channel. Not need leave.".style.warn
      end
    end
  end
end