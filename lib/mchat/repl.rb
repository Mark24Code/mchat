require_relative "./share"
require_relative "./printer"
require_relative "./message"
require "rainbow"
require_relative "./commands/common"
require_relative "./commands/channel"
require_relative "./commands/join"
require_relative "./commands/message"

module MiniChat
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
    include MiniChat::Commands::Quit

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
