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
      @channel_message_poll_time = 1 # 1s
      @current_channel = nil
      @nickname = nil
    end

    include Mchat::Share

    def puts_2_printer(content)
      @printer.display(content)
    end

    def mchat_speak(content)
      puts2 Message.new({
          'user_name' => 'Mchat',
          'timestamp'=> Time.now.to_i,
          'content'=> content
        }).display
    end

    def mchat_action(content)
      puts2 Message.new({
          'user_name' => 'Mchat [action]',
          'timestamp'=> Time.now.to_i,
          'content'=> content
        }).display
    end

    alias :puts2 :puts_2_printer


    def command_help(subject = nil)
      bold = -> (text) { em(text) }
help_index_text = %Q{
#{bold.("Help: Index") }
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
        when "channel", "ch", '2'
help_text = %Q{
#{bold.("Help: Channel") }
command: /channel <channel_name> 
explain: login the channel

}
puts help_text
        when "join", "j", '3'
help_text = %Q{
#{bold.("Help: Join") }
command: /join <channel_name> 
explain: join the channel

}
puts help_text
        when "message", "m", '4'
help_text = %Q{
#{bold.("Help: Message") }
command: /message <message> 
explain: send your message

}
puts help_text
        when 'quit', 'q'
help_text = %Q{
#{bold.("Help: Quit") }
command: /q 
explain: quit the mchat.

}
puts help_text
        when 'help', 'h'
          puts help_index_text
        else
          puts help_index_text
        end
      end
    end

    def command_quit
      puts "Bye :D"
      # TODO exit life cycle
      exit 0
    end

    def command_channel(channel_name = nil)
      if !channel_name
        # 返回全部节点
        resp = ::Mchat::Api.get_channels
        all_channels = JSON.parse(resp.body).fetch("data")

        # cli
        content = em("Mchat Channels:\n") 
        all_channels.each do |c|
          content << "* #{c}\n"
        end
        content << ""
        content << "type `/join <channel_name>` to join the channel.\n"
        puts content
        
        # printer
        mchat_action("fetch all channels")
        # puts2 content
      else
        # 指定节点
        resp = ::Mchat::Api.get_channel(channel_name)
        data = JSON.parse(resp.body).fetch("data")

        online_users = data["online_users"]
        
        # cli
        content = "#{em("Mchat Channel:")} #{channel_name}\n"
        content << "#{rfont("online users:").green}\n"
        online_users.each do |c|
          c = c.split(':').last # name
          content << "* #{rfont(c).green}\n"
        end
        content << ""
        content << "total: #{online_users.length}.\n"
        puts content
        
        # printer
        mchat_action("channel #{channel_name} info:")
        # puts2 content
      end
    end

    def command_join(channel_name = nil)
      if !channel_name
        puts warn("channel_name missing !\n type`/join <channel_name>`")
      else
        # TODO channel password
        # TODO channel 白名单
        resp = ::Mchat::Api.get_channels
        all_channels = JSON.parse(resp.body).fetch("data")

        if all_channels.any? channel_name
          mchat_action("join channel: #{channel_name}")
          @current_channel = channel_name
          fetch_channel_task
        else
          puts warn("Channel: #{channel_name} not found!")
        end
      end
    end

    def fetch_channel_task
      Thread.new do
        last_news_time = 0
        while @current_channel
          resp = ::Mchat::Api.fetch_channel_message(@current_channel)
          data = JSON.parse(resp.body).fetch("data")
          messages = data["messages"] || []

          news = messages.select { |m| m["timestamp"].to_i > last_news_time.to_i }
          news.sort! { |a, b| a["timestamp"].to_i <=> b['timestamp'].to_i}

          if news.length > 0
            content = ""
            news.each do |m|
              content << Message.new(m).display
            end
            puts2 content
            last_news_time = news.last["timestamp"]
          end
          sleep @channel_message_poll_time
        end
      end
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

    def rfont(content)
      Rainbow(content)
    end

    def em(content)
      "#{rfont(content).bold.cyan}"
    end

    def warn(content)
      "#{rfont(content).bold.yellow}"
    end

    def danger(content)
      "#{rfont(content).bold.red}"
    end

    def parser(raw)
      words = raw.strip
      case words
      when /^\/help\s{1}(.*)/, /^\/h\s{1}(.*)/, '/help', '/h'
        dispatcher('help', $1)
      when /^\/channel\s{1}(.*)/, /^\/ch\s{1}(.*)/,'/channel','/ch'
        dispatcher('channel', $1) 
      when /^\/join\s{1}(.*)/, /^\/j\s{1}(.*)/,'/join','/j'
        dispatcher('join', $1) 
      when /^\/message\s{1}(.*)/, /^\/m\s{1}(.*)/, '/message','/m'
        dispatcher('message', $1)
      when '/quit', '/q'
        dispatcher('quit')
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
      puts em("/h[elp] for help")
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
