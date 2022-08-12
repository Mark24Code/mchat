require_relative "./share"
require_relative "./printer"
require_relative "./message"
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

    # Command Channel
    module Channel
      def command_channel_help
        puts %Q(
             #{bold("Help: Channel")}
command: /channel <channel_name>
explain: login the channel

)
      end

      def command_channel(channel_name = nil)
        if !channel_name
          # 返回全部节点
          resp = ::MiniChat::Api.get_channels
          all_channels = JSON.parse(resp.body).fetch("data")

          # cli
          content = em("Minichat Channels:\n")
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
          resp = ::MiniChat::Api.get_channel(channel_name)
          data = JSON.parse(resp.body).fetch("data")

          online_users = data["online_users"]

          # cli
          content = "#{em("Minichat Channel:")} #{channel_name}\n"
          content << "#{rfont("online users:").green}\n"
          online_users.each do |c|
            c = c.split(":").last # name
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
    end

    # Command Join
    module Join
      def command_join_help
        puts %Q(
             #{bold("Help: Join")}
command: /join <channel_name>
explain: join the channel

)
      end

      def command_join(channel_name = nil)
        if !channel_name
          puts warn("channel_name missing !\n type`/join <channel_name>`")
        else
          # TODO channel password
          # TODO channel 白名单
          resp = ::MiniChat::Api.get_channels
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

    end

    # Command Message
    module Message
      def command_message_help
        puts %Q(
             #{bold("Help: Message")}
command: /message <message>
explain: send your message

)
      end

      def command_message(words)
        # TODO send to server
        # puts2("#{Message.new(words).display}")
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

  # Core REPL class
  class Repl
    def initialize
      # TODO use config
      # read config
      @wait_prefix = "u>>"
      @display_welcome = true
      @output = "./chat.log"
      @printer = Printer.new(@output)
      @channel_message_poll_time = 1 # 1s
      @current_channel = nil
      @nickname = nil
    end

    include MiniChat::Share
    include MiniChat::Commands::Guide
    include MiniChat::Commands::Channel
    include MiniChat::Commands::Join
    include MiniChat::Commands::Message
    include MiniChat::Commands::Default
    include MiniChat::Commands::Help

    def puts_2_printer(content)
      @printer.display(content)
    end

    def mchat_speak(content)
      puts2 Message.new({
                          "user_name" => "Minichat",
                          "timestamp" => Time.now.to_i,
                          "content" => content
                        }).display
    end

    def mchat_action(content)
      puts2 Message.new({
                          "user_name" => "Minichat [action]",
                          "timestamp" => Time.now.to_i,
                          "content" => content
                        }).display
    end

    alias puts2 puts_2_printer

    def bold(text)
      em(text)
    end

    def fetch_channel_task
      Thread.new do
        last_news_time = 0
        while @current_channel
          resp = ::MiniChat::Api.fetch_channel_message(@current_channel)
          data = JSON.parse(resp.body).fetch("data")
          messages = data["messages"] || []

          news = messages.select { |m| m["timestamp"].to_i > last_news_time.to_i }
          news.sort! { |a, b| a["timestamp"].to_i <=> b["timestamp"].to_i }

          if news.length.positive?
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

    def command_dispatcher(name, content = nil)
      if content
        __send__("command_#{name}", content)
      else
        __send__("command_#{name}")
      end
    end

    def help_dispatcher(name)
      __send__("command_#{name}_help")
    end

    def rfont(content)
      Rainbow(content)
    end

    def em(content)
      "#{rfont(content).boldcyan}"
    end

    def warn(content)
      "#{rfont(content).boldyellow}"
    end

    def danger(content)
      "#{rfont(content).boldred}"
    end

    def parser(raw)
      words = raw.strip
      pattern_factory = ->(keyword) { %r{^/#{keyword}\s{1}([^s]+.*?)} }
      case words
      when pattern_factory.call("help"), pattern_factory.call("h"), "/help", "/h"
        command_dispatcher("help", $1)
      when pattern_factory.call("channel"), pattern_factory.call("ch"), "/channel", "/ch"
        command_dispatcher("channel", $1)
      when pattern_factory.call("join"), pattern_factory.call("j"), "/join", "/j"
        command_dispatcher("join", $1)
      when pattern_factory.call("message"), pattern_factory.call("m"), "/message", "/m"
        command_dispatcher("message", $1)
      when "/quit", "/q"
        command_dispatcher("quit")
      when %r{^/([a-zA-Z]+)\s{1}([^s]+.*?)}, %r{^/([a-zA-Z]+)$}
        puts warn("[MiniChat] `/#{$1}`command not found.")
      else
        command_dispatcher("default", words)
      end
    end

    def tick
      #   begin
      printf @wait_prefix
      user_type_in = gets
      # puts "===[debug+]==="
      # p user_type_in
      # puts "===[debug-]==="
      # system('clear')
      parser(user_type_in)
      sleep 0.1
      # rescue => exception
      #   p exception
      # end
    end

    def init_help_message
      puts "MiniChat v1.0.0"
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
      loop do
        tick
      end
    end
  end

end

MiniChat::Repl.new.run
