require_relative './share'
require_relative './printer'
require_relative './message'
require "rainbow"
module Mchat
  class Repl
    def initialize
      # TODO use config
      # read config
      @wait_prefix = "u>>"
      @display_welcome = true
      @output = './chat.log'
      @printer = Printer.new(@output)
    end

    include Mchat::Share

    def puts_2_printer(content)
      @printer.display(content)
    end

    def rfont(content)
      Rainbow(content)
    end

    alias :puts2 :puts_2_printer

    def command_channel(channel)
      puts "command_channel #{channel}"
    end

    def command_help(subject = nil)
      bold = -> (text) { rfont(text).bold }
help_index_text = %Q{
#{bold.("Help: Index") }
Choose subject to help:
1. guide 
2. h[elp]
3. ch[annel]
4. m[essage]
5. q[uit]

e.g:
type `/h guide` you will find guide guide.
type `/h 1` work fine too.

}
      if subject == nil


      puts help_index_text

      else
        case subject.strip
        when 'guide', '1'
help_text = %Q{
#{bold.("Help: Guide") }
Mchat is a tiny chat software.

Howto:

.....


}
puts help_text
        when "channel", "ch", '3'
help_text = %Q{
#{bold.("Help: Channel") }
command: /channel <channel_name> 
explain: login the channel

}
puts help_text
        when "message", "m", '4'
help_text = %Q{
#{bold.("Help: Message") }
command: /message <message> 
explain: send your message

}
puts help_text
        when 'quit', 'q', '5'
help_text = %Q{
#{bold.("Help: Quit") }
command: /q 
explain: quit the mchat.

}
puts help_text
        when 'help', 'h', '2'
          puts help_index_text
        else
          puts help_index_text
        end
      end
    end

    def command_exit
      puts "Bye :D"
      # TODO exit life cycle
      exit 0
    end

    def command_message(words)
      # TODO send to server
      # puts2("#{Message.new(words).display}")
    end

    def command_default(words)
      puts "[default]" +  words
    end

    def dispatcher(name, content = nil)
      if content
        __send__("command_#{name}", content)
      else
        __send__("command_#{name}")
      end
    end

    def warn(content)
      Rainbow(content).bold.yellow
    end

    def parser(raw)
      words = raw.strip
      case words
      when '/help', '/h'
        dispatcher('help', nil)
      when /^\/help\s{1}(.*)/, /^\/h\s{1}(.*)/
        dispatcher('help', $1)
      when /^\/channel\s{1}(.*)/, /^\/ch\s{1}(.*)/
        dispatcher('channel', $1)
      when /^\/message\s{1}(.*)/, /^\/m\s{1}(.*)/
        dispatcher('message', $1)
      when '/quit', '/q'
        dispatcher('exit')
      when /^\/([a-zA-Z]+)\s{1}(.*)/, /^\/([a-zA-Z]+)/
        puts warn("[Mchat] `/#{$1}`command not found.")
      else
        dispatcher('default', words)
      end
    end


    def tick
      #   begin
          printf @wait_prefix; typein = gets
          # puts "===[debug+]==="
          # p typein
          # puts "===[debug-]==="
          # system('clear')
          parser(typein)
          sleep 0.1
        # rescue => exception
        #   p exception
        # end
    end

    def init_help_message
      puts "Mchat v1.0.0"
      puts "/h[elp] for help"
      puts ""
    end

    def before_loop_setup
      # cli
      puts welcome(@display_welcome)
      init_help_message
      # chat printer
      puts2 welcome(@display_welcome)
      puts2 conn_server
    end

    def run
      before_loop_setup
      while true
        tick
      end
    end
  end
  
end


Mchat::Repl.new.run
