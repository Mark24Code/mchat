module Mchat
  module Command
    module Quit
      def self.configure(repl)
        CommandConditions.push({
          name: 'quit',
          description: "q[uit]\t\tquit mchat",
          help_condition: ['quit','q'],
          help_doc: :quit_help_doc,
          command_condition: ['/quit', '/q'],
          command_run: :quit_command_run
        })
      end

      module InstanceMethods
        def quit_help_doc
          _puts QuitDoc
        end

        def quit_command_run(words=nil)
          _puts "Bye :D"
          # TODO exit life cycle
          exit 0
        end
      end
QuitDoc = %Q(
#{"Help: Quit".style.bold}

command: /q
explain: quit the mchat.

)
    end
    mount_command :quit, Quit
  end
end
