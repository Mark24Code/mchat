module Mchat
  module Command
    # Command Join
    module Name
      def name_help_doc
        _puts %Q(
             #{"Help: Name".style.bold}
command: /name <your name in channel>
explain: give your name in channel for chatting.
)
      end

      def def name_command_run(user_name = nil)
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
end
