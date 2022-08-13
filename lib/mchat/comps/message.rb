module Mchat
  class Message
    def initialize(message, format = :std)
      @message = message
      @format = format
    end

    def display
      if @format == :std
        # Time format https://devdocs.io/ruby~3/datetime#method-i-strftime
        tstring = Time.at(@message['timestamp'].to_i).strftime("%H:%M:%S")
        username = @message['user_name']
        content = @message['content']
        "[#{tstring.style.sea}] #{username.style.jade}: #{content.strip}\n"
      end
    end
  end
end