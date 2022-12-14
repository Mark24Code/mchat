require 'pathname'
require 'rainbow'
require_relative './store'

module Mchat
  class TimelineCommand
    attr_accessor :name, :data, :used
    def initialize(name, data = nil)
      # name for log
      @name = name
      @data = data
      @used = false
    end
  end

  class Timeline
    def initialize
      @reader = Mchat::Store.new({
        field_name: :messages
      })

      @boss_mode = false
    end

    # 约定和cli交互用api_xx方法
    def api_clear
      system('clear')
    end

    def api_bossmode
      # toggle api
      @boss_mode = !@boss_mode

      thx = nil
      if @boss_mode
        system('clear')
        boss_will_see_fake_logs
      else
        sleep 2
        system('clear')
        puts "======= Recover last 100 ==========="
        @reader.messages_history(100).each do |m|
          if m.is_a? String || Rainbow::Presenter
            puts m
          end
        end
        puts "======= Recover last 100 ==========="
      end
    end

    def api_close_window
      @reader.store_messages_reader_run = false
    end

    def hook_close
      @reader.hook_quit
      system('screen -X quit')
      exit 0
    end

    def dispatch(m)
      cmd_name = m.name
      data = m.data || nil

      api_name = "api_#{cmd_name}".to_sym
      if data
        __send__(api_name, data)
      else
        __send__(api_name)
      end
    end

    def boss_will_see_fake_logs
      fake_logs = File.open(Pathname.new(File.join(__dir__, './fake_log.txt'))).readlines
      thx = Thread.new {
        while @boss_mode
          fake_logs.each do |line|
            puts line
            sleep 0.1
          end
        end
      }
    end

    def run
      @reader.message_loop_reader { |messages|
        messages.each do |m|
          if m.is_a? String || Rainbow::Presenter
            if !@boss_mode
              puts m
            end
          elsif m.is_a? Mchat::TimelineCommand
            dispatch(m)
          end
        end
      }
      hook_close
    end
  end
end


if __FILE__ == $0
  tl = Mchat::Timeline.new

  trap("INT") { tl.hook_close }

  tl.run
end