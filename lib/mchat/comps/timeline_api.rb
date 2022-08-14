require_relative '../timeline'

module Mchat
  module TimelineApi
    def timeline_clear
      _chat_screen_print(TimelineCommand.new(:clear))
    end

    def timeline_bossmode
      _chat_screen_print(TimelineCommand.new(:bossmode))
    end
  end
end
