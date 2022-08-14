require_relative './store'
require 'thread'

writer = Object.new
writer.extend Mchat::Store
writer.extend Mchat::Store::Config

writer.instance_eval {
  store = get_store

  message_writer("hello world")
}
