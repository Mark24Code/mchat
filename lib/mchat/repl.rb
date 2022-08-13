require_relative "./version"

require_relative "./comps/font"
# monkey patch!
# give String styles
class String
  include Mchat::Style
end

require_relative "./api"
require_relative "./comps/printer"
require_relative "./comps/welcome"
require_relative "./comps/message"
# require_relative "./commands/common"
# require_relative "./commands/channel"
# require_relative "./commands/join"
# require_relative "./commands/name"
# require_relative "./commands/leave"
# require_relative "./commands/message"
# require_relative "./commands/clear"


module Mchat
  module Command
    # Class ########################3
    CommandComps = {}
    CommandConditions = []

    def self.mount_command(name, mod)
      CommandComps[name] = mod
    end

    def self.load_command(name)
      h = CommandComps
      unless cmd = h[name]
        require_relative "./commands/#{name}"
        raise RodaError, "command #{name} did not mount itself correctly in Mchat::Command" unless cmd = h[name]
      end
      cmd
    end

    def self.command(cmd, *args, &block)
      p cmd
      cmd = Mchat::Command.load_command(cmd) if cmd.is_a?(Symbol)
      raise MchatError, "Invalid cmd type: #{cmd.class.inspect}" unless cmd.is_a?(Module)

      include(cmd::InstanceMethods) if defined?(cmd::InstanceMethods)
      extend(cmd::ClassMethods) if defined?(cmd::ClassMethods)
      cmd.configure(self, *args, &block) if cmd.respond_to?(:configure)
    end
  end
end

module Mchat
  # Core REPL class
  class Repl

    include Command

    Command.command :quit

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

      @clear_repl_everytime = true # global lock

      @current_channel = nil
      @current_nickname = nil
    end

    def _current_channel
      @current_channel
    end

    def _current_nickname
      @current_nickname
    end

    def _chat_screen_print(content)
      # TODO add log
      @printer.display(content)
    end

    def _cli_screen_print(content)
      # TODO add log
      puts content
    end

    alias _puts  _cli_screen_print
    alias _puts2 _chat_screen_print

    include Mchat::Welcome
    # include Mchat::Commands::Guide
    # include Mchat::Commands::Channel
    # include Mchat::Commands::Join
    # include Mchat::Commands::Name
    # include Mchat::Commands::Leave
    # include Mchat::Commands::Message
    # include Mchat::Commands::Default
    # include Mchat::Commands::Help
    # include Mchat::Commands::Quit
    # include Mchat::Commands::Clear

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

    def dispatch_command(name, content = nil)
      if content
        __send__(name, content)
      else
        __send__(name)
      end
    end

    def dispatch_help(name)
      __send__("command_#{name}_help")
    end


    class_eval(%Q(
      def parser(raw)
        words = raw.strip
        CommandConditions.each do |command|
          command_condition = command[:command_condition]
          command_condition.each do |cc|
            if cc.match(words)
              dispatch_command(command[:command_run], words)
            end
          end
        end
      end
    ))


    def user_hint_prefix
      printf "#{_current_channel ? '['+_current_channel+']' : '' }#{_current_nickname ? '@'+_current_nickname : '' }#{@wait_prefix}"
    end

    def tick
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
        tick
      end
    end

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



Mchat::Repl.new.run
