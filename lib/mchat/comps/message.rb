module Mchat
  class Message
    def initialize(message, format = :std)
      @message = message
      @format = format
    end

    def display
      if @format == :std
        # Time format https://devdocs.io/ruby~3/datetime#method-i-strftime
        "[#{Time.at(@message["timestamp"].to_i).strftime("%H:%M:%S").style.blue}] #{@message["user_name"].style.bold.green}: #{@message["content"].strip}\n"
      end
    end
  end
end