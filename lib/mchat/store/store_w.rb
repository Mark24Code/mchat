require_relative './store'
require 'thread'

o = Object.new
o.extend Mchat::Store::Config

o.instance_eval {
  store = get_store

  thx = Thread.new {
    store.transaction do
      store[:messages_history] ||= Array.new
      store[:messages] ||= Array.new
    end

    loop do
      store.transaction do
        t = Time.now.to_i
        puts t
        store[:messages] << t
      end
      sleep 2
    end
  }

  thx.join
}
