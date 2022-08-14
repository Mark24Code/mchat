require_relative '../timeline'

module Mchat
  module TimelineApi
    def timeline_clear
      _chat_screen_print(TimelineCommand.new(:clear))
    end
  end
end
