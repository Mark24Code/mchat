require_relative "../share"
require_relative "../printer"
require_relative "../message"
require "rainbow"
module MiniChat
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
          help_dispatcher "help"
        else
          case subject.strip
          when "guide", "1"
            help_dispatcher "guide"
          when "channel", "ch", "2"
            help_dispatcher "channel"
          when "join", "j", "3"
            help_dispatcher "join"
          when "message", "m", "4"
            help_dispatcher "message"
          when "quit", "q"
            help_dispatcher "quit"
          when "help", "h"
            help_dispatcher "help"
          else
            help_dispatcher "default"
          end
        end
      end
    end

    # Command Guide
    module Guide
      def command_guide_help
        puts %Q(
             #{bold("Help: Guide")}
Minichat is a tiny chat software.

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