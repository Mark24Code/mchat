require 'rainbow'
require_relative './store/store'

module Mchat
  class TimelineCommand
    attr_accessor :name, :data
    def initialize(name, data = nil)
      # name for log
      @name = name
      @data = data
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
      fake_logs = File.open('./fake_log.txt').readlines
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
    end
  end
end


