module Mchat
  module Command
    # Command Message
    module Message
      def message_help_doc
        _puts %Q(
             #{"Help: Message".style.bold}
command: /message <message>
explain: send your message

)
      end

      def _command_runmessage(words)
        if !_current_channel
          _puts "You are not in channel, so you cannot message.".style.warn
          _puts "type `/n[ame] <your name>` before chat".style.warn
        elsif !_current_nickname
          _puts "You must register a name to this channel".style.warn
          _puts "type `/n[ame] <your name>` before chat".style.warn
        elsif _current_channel && _current_nickname
          resp = ::Mchat::Api.create_channel_message(_current_channel, _current_nickname, words)
          code = resp.fetch("code")

          if code != StatusCode::Success
            _puts warn "Send Message Fail:"
            _puts "quote----"
            _puts "#{words}"
            _puts "---------"
          else
            _puts "send success"
          end
        end
        # TODO send to server
        # _puts2("#{Message.new(words).display}")
      end
    end
  end
end
