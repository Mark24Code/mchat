module Mchat
  module Command
    module Guide
      CommandConditions.push({
        name: 'guide',
        description: 'guide & HOWTO',
        help_condition: ['guide'],
        help_doc: :guide_help_doc,
        command_condition: ['/guide'],
        command_run: :guide_command_run
      })

      def guide_help_doc
        _puts %Q(
             #{"Help: Guide".style.bold}
Mchat is a tiny chat software.

Howto:

.....


)
      end

      def guide_command_run
        _puts "TODO run command guide"
      end
    end
    mount_command :guide, Guide
  end
end

