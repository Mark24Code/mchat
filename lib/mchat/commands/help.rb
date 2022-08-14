module Mchat
  module Command
    module Help
      def self.configure(repl)
        CommandConditions.push({
          name: 'help',
          description: "h[elp]\t\tfind help",
          help_condition: ['help','h'],
          help_doc: :help_help_doc,
          command_condition: ['/help', /\/help (.*)/, '/h', /\/h (.*)/],
          command_run: :help_command_run
        })
      end
      module InstanceMethods
        def help_help_doc
          cmd_list = ""
          CommandConditions.each do |c|
            cmd_list << "#{c[:description]}\n"
          end

          _puts %Q(
#{"Help: Index".style.bold}

Choose subject to help:

#{cmd_list}

e.g:
type `/h guide` you will find guide guide.
)
        end

        def help_command_run(subject = nil)
          if !subject
            return help_help_doc
          end
          subject = subject && subject.strip
          catch :halt do
            CommandConditions.each do |command|
              help_condition = command[:help_condition]
              help_condition.each do |hc|
                if hc.match(subject)
                  catch_subject =  $1 ? $1 : nil
                  _dispatch(command[:help_doc], catch_subject)
                  throw :halt
                end
              end
            end
          end
        end
      end
    end
    mount_command :help, Help
  end
end
