require_relative './store'
require 'thread'

reader = Object.new
reader.extend Mchat::Store
reader.extend Mchat::Store::Config

reader.instance_eval {
  store = get_store
  message_loop_reader { |messages|
    messages.each do |m|
      puts m
    end
  }
}
