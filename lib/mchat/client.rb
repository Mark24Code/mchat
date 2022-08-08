# require "curses"
require "thread"
require_relative './logger'
require_relative './message'
require_relative './message_queue'
require_relative './share'
module Mchat
  class ChatListView
    attr :id, :data
    def initialize(id)
      @id = id
      @message_queue = ::Mchat::MessageQueue.new
      @size = 20

      # test
      @message_queue.push([
        { timestamp: 1659936455, uid: 'Mark24', content: "wo de gushi"},
        { timestamp: 1659936455, uid: 'Linda', content: "展示中文"},
      ])
    end

    def push(message)
      @message_queue.push(message)
    end

    def render
      @message_queue.data.map do |i|
        Message.new(i).display
      end
    end
  end


  class Client
    include Share
    def initialize
      @welcome_display = true
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
      welcome(@welcome_display)
      main_loop
    end
  end
end


if __FILE__ == $0
  # just for develop
  ::Mchat::Client.new.run
end
