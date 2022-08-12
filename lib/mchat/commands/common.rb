module Mchat
  module Commands
    # Command Quit
    module Quit
      def command_quit_help
        puts %Q(
             #{bold("Help: Quit")}
command: /q
explain: quit the mchat.

)
      end

      def command_quit
        puts "Bye :D"
        # TODO exit life cycle
        exit 0
      end
    end

    # Command Help
    module Help
      def command_help_help
        puts %Q(
             #{bold("Help: Index")}
Choose subject to help:
1. guide
2. ch[annel]
3. j[oin]
4. m[essage]
   q[uit]
   h[elp]

e.g:
type `/h guide` you will find guide guide.
type `/h 1` work fine too.

)
      end

      def command_help(subject = nil)

        if subject == nil
          dispatch_help "help"
        else
          case subject.strip
          when "guide", "1"
            dispatch_help "guide"
          when "channel", "ch", "2"
            dispatch_help "channel"
          when "join", "j", "3"
            dispatch_help "join"
          when "message", "m", "4"
            dispatch_help "message"
          when "quit", "q"
            dispatch_help "quit"
          when "help", "h"
            dispatch_help "help"
          else
            dispatch_help "default"
          end
        end
      end
    end

    # Command Guide
    module Guide
      def command_guide_help
        puts %Q(
             #{bold("Help: Guide")}
Mchat is a tiny chat software.

Howto:

.....


)
      end

      def command_guide
        puts "TODO run command guide"
      end
    end

    # Command Default
    module Default

      def command_default_help
        puts %Q(
             #{bold("Help: Default")}
there is nothing

)
      end

      def command_default(words)
        puts "[default]#{words}"
      end

    end

  end
end