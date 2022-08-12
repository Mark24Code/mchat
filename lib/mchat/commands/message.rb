module Mchat
  module Commands
    # Command Message
    module Message
      def command_message_help
        puts %Q(
             #{"Help: Message".style.bold}
command: /message <message>
explain: send your message

)
      end

      def command_message(words)
        if !@current_channel
          puts warn("You are not in channel, so you cannot message.")
          puts warn("type `/n[ame] <your name>` before chat")  
        elsif !@current_nickname
          puts warn("You must register a name to this channel")
          puts warn("type `/n[ame] <your name>` before chat")
        elsif @current_channel && @current_nickname
          resp = ::Mchat::Api.create_channel_message(@current_channel, @current_nickname, words)
          code = JSON.parse(resp.body).fetch("code")

          if code != StatusCode::Success
            puts warn "Send Message Fail:"
            puts "quote----"
            puts "#{words}"
            puts "---------"
          else
            puts "send success"
          end
        end
        # TODO send to server
        # puts2("#{Message.new(words).display}")
      end
    end
  end
end