module Mchat
  module Command
    # Command Clear
    module Clear
      def self.configure(repl)
        CommandConditions.push({
          name: 'c[lear]',
          description: 'clean mchat screen',
          help_condition: ['clear','c'],
          help_doc: :clear_help_doc,
          command_condition: ['/clear', '/c'],
          command_run: :clear_command_run
        })
      end
      module InstanceMethods
        def clear_help_doc
          _puts %Q(
               #{"Help: Clear".style.bold}
  command: /clear
  explain: clear chat screen.
  )
        end

        def clear_command_run(repl = nil)
          _printer.clear
        end
      end
    end

    mount_command :clear, Clear
  end
end
