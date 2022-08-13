module Mchat
  module Commands
    # Command Quit
    module Quit
      def command_quit_help
        _puts %Q(
             #{"Help: Quit".style.bold}
command: /q
explain: quit the mchat.

)
      end

      def command_quit
        _puts "Bye :D"
        # TODO exit life cycle
        exit 0
      end
    end

    # Command Help
    module Help
      def command_help_help
        _puts %Q(
             #{"Help: Index".style.bold}
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
        _puts %Q(
             #{"Help: Guide".style.bold}
Mchat is a tiny chat software.

Howto:

.....


)
      end

      def command_guide
        _puts "TODO run command guide"
      end
    end

    # Command Default
    module Default

      def command_default_help
        _puts %Q(
             #{"Help: Default Mode".style.bold}
if you have joined `channel`
and you have a `name` in channel

you can send message without /m  command, that's default mode.

)
      end

      def command_default(words)
        if _current_channel && _current_nickname
          command_message(words)
        else
          _puts "Oops.. This is `Default Mode`:".style.warn
          _puts "if you join channel and have name, it will send message.".style.warn
          _puts "Do nothing. maybe you need join channel or use commands. try /h for more.".style.warn
        end
      end

    end

  end
end
