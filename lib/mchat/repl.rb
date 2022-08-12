require "rainbow"
require_relative "./share"
require_relative "./status_code"
require_relative "./printer"
require_relative "./message"
require_relative "./commands/common"
require_relative "./commands/channel"
require_relative "./commands/join"
require_relative "./commands/name"
require_relative "./commands/leave"
require_relative "./commands/message"

module Mchat
  # Core REPL class
  class Repl
    def initialize
      # TODO use config
      # read config
      @wait_prefix = ">>"
      @display_welcome = true
      @output = "./chat.log"
      @printer = Printer.new(@output)
      @channel_message_poll_time = 1 # 1s
      @channel_message_poll_running = false
      @current_channel = nil
      @current_nickname = nil
    end

    include Mchat::Share
    include Mchat::Commands::Guide
    include Mchat::Commands::Channel
    include Mchat::Commands::Join
    include Mchat::Commands::Name
    include Mchat::Commands::Leave
    include Mchat::Commands::Message
    include Mchat::Commands::Default
    include Mchat::Commands::Help
    include Mchat::Commands::Quit

    def puts_2_printer(content)
      @printer.display(content)
    end

    def mchat_speak(content)
      puts2 Message.new({
                          "user_name" => "Mchat",
                          "timestamp" => Time.now.to_i,
                          "content" => content
                        }).display
    end

    def mchat_action(content)
      puts2 Message.new({
                          "user_name" => "Mchat [action]",
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
        while @current_channel && @channel_message_poll_running
          resp = ::Mchat::Api.fetch_channel_message(@current_channel)
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

    def dispatch_command(name, content = nil)
      if content
        __send__("command_#{name}", content)
      else
        __send__("command_#{name}")
      end
    end

    def dispatch_help(name)
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
        dispatch_command("help", $1)
      when pattern_factory.call("channel"), pattern_factory.call("ch"), "/channel", "/ch"
        dispatch_command("channel", $1)
      when pattern_factory.call("join"), pattern_factory.call("j"), "/join", "/j"
        dispatch_command("join", $1)
      when pattern_factory.call("name"), pattern_factory.call("n"), "/name", "/n"
        dispatch_command("name", $1)
      when "/leave", "/l"
        dispatch_command("leave")
      when pattern_factory.call("message"), pattern_factory.call("m"), "/message", "/m"
        dispatch_command("message", $1)
      when "/quit", "/q"
        dispatch_command("quit")
      when %r{^/([a-zA-Z]+)\s{1}([^s]+.*?)}, %r{^/([a-zA-Z]+)$}
        puts warn("[Mchat] `/#{$1}`command not found.")
      else
        dispatch_command("default", words)
      end
    end

    def user_hint_prefix
      printf "#{@current_channel ? '['+@current_channel+']' : '' }#{@current_nickname ? '@'+@current_nickname : '' }#{@wait_prefix}"
    end

    def tick
      #   begin
      user_hint_prefix
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
      loop do
        tick
      end
    end
  end

end

Mchat::Repl.new.run
