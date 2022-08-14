module Mchat
  module Command
    # Command Clear
    module BossMode
      def self.configure(repl)
        CommandConditions.push({
          name: 'bossmode',
          description: "b[ossmode]\tclean mchat screen & print fake logs",
          help_condition: ['bossmode'],
          help_doc: :bossmode_help_doc,
          command_condition: ['/bossmode', '/b'],
          command_run: :bossmode_command_run
        })
      end
      module InstanceMethods
        def bossmode_help_doc
        _puts %Q(
#{"Help: BossMode".style.bold}

command: /bossmode
explain: clear chat screen and print fake logs. use agan recover messages.

  )
        end

        def bossmode_command_run(repl = nil)
          timeline_bossmode
        end
      end
    end

    mount_command :bossmode, BossMode
  end
end
