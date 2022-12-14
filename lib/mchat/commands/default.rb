module Mchat
  module Command
    module Default
      CommandConditions.push({
        name: 'default',
        description: "default\t\tdefault model, send message",
        help_condition: ['default'],
        help_doc: :default_help_doc,
        command_condition: [/([^\s].*)/],
        command_run: :default_command_run
      })
      module InstanceMethods
        def default_help_doc
          _puts %Q(
#{"Help: Default Mode".style.bold}

if you have joined `channel`
and you have a `name` in channel

you can send message without /m  command, that's default mode.

      )
        end

        def default_command_run(words)
          if _current_channel && _current_nickname && words
            return message_command_run(words)
          else
            _puts "Oops.. This is `Default Mode`:".style.warn
            _puts "if you join channel and have name, it will send message.".style.warn
            _puts "Do nothing. maybe you need join channel or use commands. try /h for more.".style.warn
          end
        end
      end
    end
    mount_command :default, Default
  end
end

