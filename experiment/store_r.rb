require_relative './store'
require 'thread'

reader = Mchat::Store.new({
  field_name: :messages
})

reader.message_loop_reader { |messages|
  messages.each do |m|
    puts m
  end
}
