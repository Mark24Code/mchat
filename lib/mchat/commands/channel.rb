module Mchat

  module Commands
    # Command Channel
    module Channel
      def command_channel_help
        puts %Q(
             #{bold("Help: Channel")}
command: /channel <channel_name>
explain: login the channel

)
      end

      def command_channel(channel_name = nil)
        if !channel_name
          # 返回全部节点
          resp = ::Mchat::Api.get_channels
          all_channels = JSON.parse(resp.body).fetch("data")

          # cli
          content = em("Mchat Channels:\n")
          all_channels.each do |c|
            content << "* #{c}\n"
          end
          content << ""
          content << "type `/join <channel_name>` to join the channel.\n"
          puts content

          # printer
          mchat_action("fetch all channels")
          # puts2 content
        else
          # 指定节点
          resp = ::Mchat::Api.get_channel(channel_name)
          data = JSON.parse(resp.body).fetch("data")

          online_users = data["online_users"]

          # cli
          content = "#{em("Mchat Channel:")} #{channel_name}\n"
          content << "#{rfont("online users:").green}\n"
          online_users.each do |c|
            c = c.split(":").last # name
            content << "* #{rfont(c).green}\n"
          end
          content << ""
          content << "total: #{online_users.length}.\n"
          puts content

          # printer
          mchat_action("channel #{channel_name} info:")
          # puts2 content
        end
      end
    end

  end
end