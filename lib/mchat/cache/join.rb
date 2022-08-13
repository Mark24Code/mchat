module Mchat
  module Command
    # Command Join
    module Join
      def join_help_doc
        _puts %Q(
             #{"Help: Join".style.bold}
command: /join <channel_name>
explain: join the channel

)
      end

      def _command_runjoin(channel_name = nil)
        if !channel_name
          _puts "channel_name missing !\n type`/join <channel_name>`".style.warn
        else
          # TODO channel password
          # TODO channel 白名单
          resp = ::Mchat::Api.get_channels
          all_channels = resp.fetch("data")

          if all_channels.any? channel_name
            _mchat_action("join channel: #{channel_name}")
            _current_channel = channel_name
            fetch_channel_task
          else
            _puts "Channel: #{channel_name} not found!".style.warn
          end
        end
      end

    end
  end
end
