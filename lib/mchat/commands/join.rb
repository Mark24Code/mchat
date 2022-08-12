module MiniChat
  module Commands
    # Command Join
    module Join
      def command_join_help
        puts %Q(
             #{bold("Help: Join")}
command: /join <channel_name>
explain: join the channel

)
      end

      def command_join(channel_name = nil)
        if !channel_name
          puts warn("channel_name missing !\n type`/join <channel_name>`")
        else
          # TODO channel password
          # TODO channel 白名单
          resp = ::MiniChat::Api.get_channels
          all_channels = JSON.parse(resp.body).fetch("data")

          if all_channels.any? channel_name
            mchat_action("join channel: #{channel_name}")
            @current_channel = channel_name
            fetch_channel_task
          else
            puts warn("Channel: #{channel_name} not found!")
          end
        end
      end

    end
  end
end