require_relative "./version"

require_relative "./comps/font"
# monkey patch!
# give String styles
class String
  include Mchat::Style
end

require_relative "./api"
require_relative "./command"
require_relative "./comps/printer"
require_relative "./comps/welcome"
require_relative "./comps/message"

module Mchat
  module ModApi
    def _current_channel
      @current_channel
    end

    def _set_current_channel(channel_name)
      @current_channel = channel_name
    end

    def _current_nickname
      @current_nickname
    end

    def _set_current_nickname(nickname)
      @current_nickname = nickname
    end

    def _chat_screen_print(content)
      # TODO add log
      @printer.display(content)
    end

    def _cli_screen_print(content)
      # TODO add log
      puts content
    end

    def _printer
      @printer
    end

    def _dispatch(name, content = nil)
      if content
        __send__(name, content)
      else
        __send__(name)
      end
    end

    alias _puts  _cli_screen_print
    alias _puts2 _chat_screen_print

    def _mchat_speak(content)
      _puts2 Message.new({
                          "user_name" => "Mchat",
                          "timestamp" => Time.now.to_i,
                          "content" => content
                        }).display
    end

    def _mchat_action(content)
      _puts2 Message.new({
                          "user_name" => "Mchat [action]",
                          "timestamp" => Time.now.to_i,
                          "content" => content
                        }).display
    end
  end
end
module Mchat
  # Core REPL class
  class Repl

    include Command
    include Mchat::Welcome

    install_commands = [
      :help,
      :guide,
      :channel,
      :join,
      :name,
      :message,
      :leave,
      :clear,
      :quit,
      :default
    ]

    install_commands.each do |command|
      Command.install command
    end


    # Instance ########################3

    def initialize
      # TODO use config
      # read config
      @wait_prefix = ">>"
      @display_welcome = true
      @output = "./chat.log"
      @printer = Printer.new(@output)
      @channel_message_poll_time = 1 # seconds
      @channel_message_poll_running = true # global lock

      @clear_repl_everytime = false # global lock

      @current_channel = nil
      @current_nickname = nil
    end


    def fetch_channel_task
      Thread.new do
        last_news_time = 0
        while _current_channel && @channel_message_poll_running
          resp = ::Mchat::Api.fetch_channel_message(_current_channel)
          data = resp.fetch("data")
          messages = data["messages"] || []

          news = messages.select { |m| m["timestamp"].to_i > last_news_time.to_i }
          news.sort! { |a, b| a["timestamp"].to_i <=> b["timestamp"].to_i }

          if news.length.positive?
            content = ""
            news.each do |m|
              content << Message.new(m).display
            end
            _puts2 content
            last_news_time = news.last["timestamp"]
          end
          sleep @channel_message_poll_time
        end
      end
    end

    def parser(raw)
      words = raw.strip
      catch :halt do
        CommandConditions.each do |command|
          command_condition = command[:command_condition]
          command_condition.each do |cc|
            if cc.match(words)
              content = $1 ? $1 : nil
              _dispatch(command[:command_run], content)
              throw :halt
            end
          end
        end
      end
    end

    def user_hint_prefix
      printf "#{_current_channel ? '['+_current_channel+']' : '' }#{_current_nickname ? '@'+_current_nickname : '' }#{@wait_prefix}"
    end

    include Mchat::ModApi

    def tick_work
      #   begin
      user_hint_prefix
      user_type_in = gets
      # _puts "===[debug+]==="
      # p user_type_in
      # _puts "===[debug-]==="
      @clear_repl_everytime && system('clear')
      parser(user_type_in)
      sleep 0.1
      # rescue => exception
      #   p exception
      # end
    end

    def init_help_message
      _puts "Mchat #{Mchat::VERSION}"
      _puts "/h[elp] for help".style.primary
      _puts ""
    end

    def before_loop_setup
      # cli
      _puts welcome(@display_welcome)

      init_help_message
      # chat printer
      _puts2 welcome(@display_welcome)
      _puts2 conn_server
    end

    def run
      before_loop_setup
      loop do
        tick_work
      end
    end
  end
end



Mchat::Repl.new.run
