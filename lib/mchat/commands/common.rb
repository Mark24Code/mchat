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
1. guide      : howto guide
2. ch[annel]  : find channel or fetch channel info
3. j[oin]     : join a channel
4. n[ame]     : register a name in channel for chatting
5. l[eave]    : delete name in channel
6. m[essage]  : send message in channel
   c[lear]     : clean mchat
   q[uit]     : quit mchat
   h[elp]     : find help

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
          when "name", "n", "4"
            dispatch_help "name"
          when "leave", "l", "5"
            dispatch_help "leave"
          when "message", "m", "6"
            dispatch_help "message"
          when "clear", "c"
            dispatch_help "clear"
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