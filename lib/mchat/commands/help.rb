module Mchat
  module Command
    module Help
      def self.configure(repl)
        CommandConditions.push({
          help_condition: ['help','h'],
          help_doc: :help_help_doc,
          command_condition: ['/help', '/h'],
          command_run: :help_command_run
        })
      end
      module InstanceMethods
        def help_help_doc
          _puts %Q(
#{"Help: Index".style.bold}
  Choose subject to help:
  1. guide      : howto guide
  2. ch[annel]  : find channel or fetch channel info
  3. j[oin]     : join a channel
  4. n[ame]     : register a name in channel for chatting
  5. l[eave]    : delete name in channel
  6. m[essage]  : send message in channel
    c[lear]     : clean mchat
    q[uit]     : quit mchat
    h[elp]     : find help

  e.g:
  type `/h guide` you will find guide guide.
  type `/h 1` work fine too.

  )
        end

        class_eval(%Q(
          def help_command_run(subject = nil)
            subject = subject.strip
            CommandConditions.each do |command|
              help_condition = command[:help_condition]
              help_condition.each do |hc|
                if hc.match(subject)
                  dispatch(command[:help_doc], subject)
                end
              end
            end
          end
        ))
      end
    end
    mount_command :help, Help
  end
end
