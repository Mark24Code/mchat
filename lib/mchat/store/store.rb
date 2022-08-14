require 'pathname'
require 'pstore'

module Mchat
  class Store
    def initialize(opt={})
      @store_path = opt[:store_path] || Pathname.new(Dir.home).join('mchatdb')
      @store_sync_time = opt[:store_sync_time] || 1
      @store_async_flag = opt[:store_async_flag] || false
      @field_name = opt[:field_name]
      @field_history_name = "#{@field_name.to_s}_history".to_sym

      @store = nil
    end
    def store_exist?
      File.exist? @store_path
    end
    def create_store
      PStore.new(@store_path)
    end

    def get_store
      if !store_exist?
        create_store
      end

      @store = ::PStore.new(@store_path)

      @store.transaction do
        @store[@field_history_name] ||= Array.new
        @store[@field_name] ||= Array.new
      end

      @store
    end

    def messages_history(count)
      last_messages = @store[@field_history_name].last(count)
      return last_messages
    end

    def message_writer(content)
      get_store
      @store.transaction do
        if content.is_a? Array
          @store[@field_name] += content
        else
          @store[@field_name] << content
        end
      end
    end

    def message_loop_reader
      get_store
      thx = Thread.new {
        loop do
          @store.transaction do
            messages = @store[@field_name]
            messages.each do |m|
            end
            # puts m
            if block_given?
              yield(messages)
            end
            @store[@field_history_name] += messages
            @store[@field_name] = []
          end
          sleep @store_sync_time
        end
      }

      if(!@store_async_flag)
        thx.join
      end

      return thx
    end
  end
end
