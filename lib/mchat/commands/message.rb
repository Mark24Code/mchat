module Mchat
  module Commands
    # Command Message
    module Message
      def command_message_help
        puts %Q(
             #{bold("Help: Message")}
command: /message <message>
explain: send your message

)
      end

      def command_message(words)
        if !@current_nickname
          puts warn("You must register a name to this channel")
          puts warn("type `/name <your name>` before chat")
        else
          resp = ::Mchat::Api.create_channel_message(@current_channel, @current_nickname, words)
          code = JSON.parse(resp.body).fetch("code")

          if code != StatusCode::Success
            puts warn "Send Message Fail:"
            puts "quote----"
            puts "#{words}"
            puts "---------"
          end

        end
        # TODO send to server
        # puts2("#{Message.new(words).display}")
      end
    end
  end
end