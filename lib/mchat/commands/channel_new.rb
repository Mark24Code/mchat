module Mchat
  module Command
    module ChannelNew
      def self.configure(repl)
        CommandConditions.push({
          name: 'channel_new',
          description: "channel_new\tcreate new channel",
          help_condition: ['channel_new'],
          help_doc: :channel_new_help_doc,
          command_condition: ['/channel_new', /\/channel_new (.*)/],
          command_run: :channel_new_command_run
        })
      end
      module InstanceMethods
        def channel_new_help_doc
          _puts %Q(
#{"Help: Channel New".style.bold}

command: /channel_new <new_channel_name>
explain: create a new channel

)
        end

        def channel_new_command_run(channel_name = nil)
          if !channel_name
            content << "/channel_new <new_channel_name>\n".style.warn
            content << "new_channel_name should not be nil\n".style.warn
            _puts content
          else
            # 指定节点
            resp = ::Mchat::Api.create_channel(channel_name)
            code = resp.fetch("code")

            if code == StatusCode::RecordHaveExist
              content = "#{"Mchat Channel:".style.primary} #{channel_name}\n"
              content << "channel <#{channel_name}> have exist. use follow create new channel.\n"
              content << "type `/channel_new <new_channel_name>`"
              content << "you can also find all channels:"
              content << "type `/channel`"
              _puts content
              return
            elsif code == StatusCode::Success
              # 存在这个channel
              data = resp.fetch("data")

              online_users = data["online_users"]

              # cli
              _mchat_action("you create channel: #{channel_name}")
              _puts "create channel: #{channel_name} success. try auto join."

              _dispatch(:join_command_run, channel_name)
            end
          end
        end
      end
    end
    mount_command :channel_new, ChannelNew
  end
end
