require_relative './store'
require 'thread'

writer = Mchat::Store.new({
  field_name: :messages
})

writer.message_writer("hello world")
