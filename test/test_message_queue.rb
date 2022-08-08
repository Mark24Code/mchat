# frozen_string_literal: true

require "test_helper"
require "mchat/message_queue"

class TestMchat < Minitest::Test
  def test_msg_queue
    refute_nil ::Mchat::MessageQueue.new
  end

  def test_queue_push_and_length
    q = ::Mchat::MessageQueue.new
    q.push(1)
    q.push(2)
    assert_equal 2, q.length

    q.push([3,4])
    assert_equal 4, q.length
  end

  def test_queue_empty?
    q = ::Mchat::MessageQueue.new
    assert q.empty?
  end

  def test_queue_empty_false?
    q = ::Mchat::MessageQueue.new
    q.push(1)
    assert_equal false, q.empty?
  end

  def test_queue_all
    q = ::Mchat::MessageQueue.new
    q.push(1)
    q.push(2)
    assert_equal [1,2], q.all
  end

  def test_queue_clean
    q = ::Mchat::MessageQueue.new
    q.push(1)
    q.push(2)
    assert_equal [1,2], q.all
    q.clear
    assert_equal 0, q.length
  end

  def test_virtual_message
    # 类似分页指定数字返回
    # 数据累计依赖外部维持，内部是无状态，纯计算返回
    q = ::Mchat::MessageQueue.new({view_size:2})
    q.clear
    q.push(1)
    q.push(2)
    q.push(3)
    q.push(4)
    q.push(5)
    q.push(6)
    q.push(7)
    q.push(8)
    q.push(9)
    q.push(10)
    assert_equal 10, q.length
    assert_equal [1,2,3,4,5,6,7,8,9,10], q.messages

    # view_size
    assert_equal 2, q.view_size
    
    # default get
    q.scroll_offset = 0
    assert_equal [9, 10], q.data

    # offset

    q.scroll_offset = -1
    assert_equal [8,9], q.data

    q.scroll_offset = -2
    assert_equal [7,8], q.data

    q.scroll_offset = -3
    assert_equal [6,7], q.data

    q.scroll_offset = 0
    assert_equal [9, 10], q.data

    # out of limit protect result
    # keep result correct
    q.scroll_offset = 1
    assert_equal [9, 10], q.data

    q.scroll_offset = 100
    assert_equal [9, 10], q.data

    q.scroll_offset = -100
    assert_equal [1, 2], q.data
  end

end
