module MiniChat
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
        # TODO send to server
        # puts2("#{Message.new(words).display}")
      end
    end
  end
end