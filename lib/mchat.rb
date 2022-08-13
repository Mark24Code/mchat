# frozen_string_literal: true

require_relative "mchat/version"

module Mchat
  class Error < StandardError; end
  class MchatError < StandardError; end
  # Your code goes here...
end

require_relative "./mchat/repl"
