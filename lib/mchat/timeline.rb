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

    def api_boss
      # toggle api
      system('clear')
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

    def run
      @reader.message_loop_reader { |messages|
        messages.each do |m|
          if m.is_a? String || Rainbow::Presenter
            puts m
          elsif m.is_a? Mchat::TimelineCommand
            dispatch(m)
          end
        end
      }
    end
  end
end


