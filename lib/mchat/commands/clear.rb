module Mchat
  module Commands
    # Command Clear
    module Clear
      def command_clear_help
        puts %Q(
             #{"Help: Clear".style.bold}
command: /clear
explain: clear chat screen.
)
      end

      def command_clear
        @printer.clear
      end
    end
  end
end