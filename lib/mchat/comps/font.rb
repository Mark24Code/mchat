require "rainbow"

module Mchat
  class StyleFont
    def initialize(text)
      @text = Rainbow(text)
    end

    def primary
      @text.bold.cyan
    end

    def jade
      @text.bold.green
    end

    def sea
      @text.bold.blue
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
  module Style
    def style
      ::Mchat::StyleFont.new(self)
    end
  end
end
