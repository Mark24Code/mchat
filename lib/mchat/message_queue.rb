module Mchat
  class MessageQueue
    attr_accessor :messages, :scroll_offset, :view_size
    def initialize(opt = {})
      @messages = opt[:messages] || []
      @view_size = opt[:view_size] || 20
      @virtual_messages = []
      @scroll_offset = 0

      update_virtual_messages
    end

    def update_virtual_messages
      # default  range
      if @messages.length <= @view_size
        @virtual_messages = @messages
        return  @virtual_messages
      end

      # >
      cache_max_length = @messages.length
      _default_left = cache_max_length - @view_size
      _left = _default_left + @scroll_offset

      if _left < 0
        _left = 0
      end

      if _left > _default_left
        _left = _default_left
      end

      _right = _left + @view_size

      @virtual_messages = @messages[_left .. _right - 1]
      return @virtual_messages
    
    end

    def data
      update_virtual_messages
    end

    def push(m)
      if m.instance_of? Array
        m.each do |e|
          @messages.push(e)
        end
      else 
        @messages.push(m)
      end
      
      update_virtual_messages
    end

    def length
      @messages.length
    end

    def empty?
      @messages.length <= 0
    end

    def all
      @messages
    end

    def clear
      @messages = []
      update_virtual_messages
    end

    # TODO 数据过大之后持久化
  end
end
