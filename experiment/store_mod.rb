require 'pathname'
require 'pstore'

module Mchat
  module Store
    module Config
      STORE_PATH = Pathname.new(Dir.home).join('mchatdb')
      STORE_SYNC_TIME = 1
      STORE_ASYNC_FLAG = false
      def store_exist?
        File.exist? STORE_PATH
      end
      def create_store
        PStore.new(STORE_PATH)
      end

      def get_store
        if !store_exist?
          create_store
        end

        store = ::PStore.new(STORE_PATH)

        store.transaction do
          store[:messages_history] ||= Array.new
          store[:messages] ||= Array.new
        end
        return store
      end
    end

    def message_writer(content)
      store = get_store

      store.transaction do
        if content.is_a? Array
          store[:messages] += content
        else
          store[:messages] << content
        end
      end
    end

    def message_loop_reader
      store = get_store
      thx = Thread.new {
        loop do
          store.transaction do
            messages = store[:messages]
            messages.each do |m|
            end
            # puts m
            if block_given?
              yield(messages)
            end
            store[:messages_history] += messages
            store[:messages] = []
          end
          sleep Config::STORE_SYNC_TIME
        end
      }

      if(!Config::STORE_ASYNC_FLAG)
        thx.join
      end
    end
  end
end
