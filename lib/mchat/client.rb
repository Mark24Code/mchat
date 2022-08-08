# require "curses"
require "thread"
require_relative './logger'
require "rainbow"

module Mchat

  class ListView
    attr :id
    def initialize(id)
      @id = id
      @data = []
    end

    def push(data)
      @data.push(data)
    end

    def setup
    end

  end

  class ChatListView < ListView
    def initialize(id)
      super
      @length = 20
      @data = [
        { timestamp: 1659936455, uid: 'Mark24', content: "wo de gushi"},
        { timestamp: 1659936455, uid: 'Linda', content: "展示中文"},
      ]
    end

    def render
      @data.map do |i|
        # Time format https://devdocs.io/ruby~3/datetime#method-i-strftime
        "[#{Rainbow(Time.at(i[:timestamp].to_i).strftime("%H:%M:%S")).blue}] #{Rainbow(i[:uid]).green}: #{i[:content]}"
      end
    end
  end


  class Client
    def initialize
      @focus = 'input_textpad' # default focus
      @components = []
      
      _mount_component

      init_client
    end

    def _mount_component
      @components.push(ChatListView.new('chat_timeline'))
    end

    def init_client
      @components.each do |c|
        c.render.map do |t|
          puts t
        end
      end
    end

    def main_loop

      while true
        sleep 0.1
      end
      # key_listener_thr = Thread.new { self.key_listener }
      # action_thr = Thread.new { self.action }
      # render_thr = Thread.new { self.render }

      # [key_listener_thr,action_thr, render_thr].map(&:join)
    end

    def key_listener
    end

    def action
    end

    def render
      while (frame_data = @frame_data_channel.shift)
        break if frame_data == :done
        @render.draw(frame_data) if frame_data
        sleep 0.16
      end
    end
  
    def run
      puts "hello world"

      main_loop
    end
  end
end

::Mchat::Client.new.run