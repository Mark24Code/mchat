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
          puts "You are not in channel, so you cannot message.".style.warn
          puts "type `/n[ame] <your name>` before chat".style.warn  
        elsif !@current_nickname
          puts "You must register a name to this channel".style.warn
          puts "type `/n[ame] <your name>` before chat".style.warn
        elsif @current_channel && @current_nickname
          resp = ::Mchat::Api.create_channel_message(@current_channel, @current_nickname, words)
          code = resp.fetch("code")

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