module Mchat
  module Command
    module Channel
      def self.configure(repl)
        CommandConditions.push({
          name: 'ch[annel]',
          description: 'find channel list & get channel info',
          help_condition: ['channel','ch'],
          help_doc: :channel_help_doc,
          command_condition: ['/channel', /\/channel (.*)/, '/ch', /\/ch (.*)/],
          command_run: :channel_command_run
        })
      end
      module InstanceMethods
        def channel_help_doc
          _puts %Q(
               #{"Help: Channel".style.bold}
  command: /channel <channel_name>
  explain: login the channel

  )
        end

        def channel_command_run(channel_name = nil)
          if !channel_name
            # 返回全部节点
            resp = ::Mchat::Api.get_channels
            all_channels = resp.fetch("data")

            # cli
            content = "Mchat Channels:\n".style.primary
            if all_channels.length > 0
              all_channels.each do |c|
                content << "* #{c}\n"
              end
            else
              # TODO create channel
              content << "Opps."
            end

            content << ""
            content << "type `/join <channel_name>` to join the channel.\n"
            _puts content

            # printer
            _mchat_action("fetch all channels")
            # _puts2 content
          else
            # 指定节点
            resp = ::Mchat::Api.get_channel(channel_name)
            data = resp.fetch("data")

            online_users = data["online_users"]

            # cli
            content = "#{"Mchat Channel:".style.primary} #{channel_name}\n"
            content << "#{"online users:".style.green}\n"
            online_users.each do |c|
              c = c.split(":").last # name
              content << "* #{c.style.green}\n"
            end
            content << ""
            content << "total: #{online_users.length}.\n"
            _puts content

            # printer
            _mchat_action("channel #{channel_name} info:")
            # _puts2 content
          end
        end
      end
    end
    mount_command :channel, Channel
  end
end
