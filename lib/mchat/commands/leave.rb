module Mchat
  module Command
    # Command Join
    module Leave
      def self.configure(repl)
        CommandConditions.push({
          name: 'leave',
          description: "l[eave]]\tleave channel",
          help_condition: ['leave','l'],
          help_doc: :leave_help_doc,
          command_condition: ['/leave', /\/leave (.*)/, '/l', /\/l (.*)/],
          command_run: :leave_command_run
        })
      end
      module InstanceMethods
        def leave_help_doc
          _puts %Q(
  #{"Help: Leave".style.bold}

  command: /leave
  explain: leave channel and delete your name.
  )
        end

        def leave_command_run
          if _current_nickname
            resp = ::Mchat::Api.leave_channel( _current_channel , _current_nickname)
            code = resp.fetch("code")
            if code == StatusCode::Success
              _puts "#{_current_nickname} leave success.".style.primary
              _current_nickname = nil
            else
              _puts "leave request connect fail. try again.".style.warn
            end
          else
            _puts "You are not have name in channel. Not need leave.".style.warn
          end
        end
      end
    end
    mount_command :leave, Leave
  end
end
