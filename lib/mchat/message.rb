require "rainbow"

module Mchat
  class Message
    def initialize(message, format = :std)
      @message = message
      @format = format
    end

    def display
      if @format == :std
        # Time format https://devdocs.io/ruby~3/datetime#method-i-strftime
        "[#{Rainbow(Time.at(@message[:timestamp].to_i).strftime("%H:%M:%S")).blue}] #{Rainbow(@message[:uid]).green}: #{@message[:content]}"
      end
    end
  end
end