require_relative './store'
require 'thread'

reader = Object.new
reader.extend Mchat::Store::Config

reader.instance_eval {
  store = get_store
  thx = Thread.new {
    loop do
      store.transaction do
        messages = store[:messages]
        messages.each do |m|
          puts m
        end
        store[:messages_history] += messages
        store[:messages] = []
      end
      sleep 2
    end
  }

  thx.join
}
