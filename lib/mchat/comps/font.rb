require "rainbow"

module Mchat
  class StyleFont
    def initialize(text)
      @text = Rainbow(text)
    end

    def primary
      @text.bold.cyan
    end

    def warn
      @text.bold.yellow
    end

    def danger
      @text.bold.red
    end

    def bold
      @text.bold
    end
  end
  module Font
    refine String do
      def style
        ::Mchat::StyleFont.new(self)
      end
    end
  end
end
