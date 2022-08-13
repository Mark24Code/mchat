module Mchat
  module Command
    # Command Join
    module Name
      def self.configure(repl)
        CommandConditions.push({
          name: 'name',
          description: "n[ame]\t\tset name in channel",
          help_condition: ['name','n'],
          help_doc: :name_help_doc,
          command_condition: ['/name', /\/name (.*)/, '/n', /\/n (.*)/],
          command_run: :name_command_run
        })
      end
      module InstanceMethods
        def name_help_doc
          _puts %Q(
#{"Help: Name".style.bold}

command: /name <your name in channel>
explain: give your name in channel for chatting.

  )
        end

        def name_command_run(user_name = nil)
          if _current_nickname
            _puts "You have `name` and active in this channel now.".style.warn
            _puts "Please leave this channel then change your name.".style.warn
          else
            resp = ::Mchat::Api.join_channel( _current_channel , user_name)
            code = resp.fetch("code")
            if code == StatusCode::Success
              _puts "#{user_name} is avalibale.".style.primary
              _current_nickname = user_name
            else
              _current_nickname = nil
              _puts "#{user_name} has been used in channel: #{_current_channel}\ntry rename.".style.warn
            end
          end
        end
      end
    end
    mount_command :name, Name
  end
end
