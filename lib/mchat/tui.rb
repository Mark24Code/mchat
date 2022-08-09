require 'curses'

module Tui
  module FontStyle
    # 值来源
    # ext/curses/curses.c
    NORMAL        = Curses::A_NORMAL       # Normal display (no highlight)
    STANDOUT      = Curses::A_STANDOUT     # Best highlighting mode of the terminal.
    UNDERLINE     = Curses::A_UNDERLINE    # Underlining
    REVERSE       = Curses::A_REVERSE      # Reverse video
    BLINK         = Curses::A_BLINK        # Blinking
    DIM           = Curses::A_DIM          # Half bright
    BOLD          = Curses::A_BOLD         # Extra bright or bold
    PROTECT       = Curses::A_PROTECT      # Protected mode
    INVIS         = Curses::A_INVIS        # Invisible or blank mode
    ALTCHARSET    = Curses::A_ALTCHARSET   # Alternate character set
    CHARTEXT      = Curses::A_CHARTEXT     # Bit-mask to extract a character
    # COLOR_PAIR(n) = Curses::COLOR_PAIR(n)  # Color-pair number n
  end

  module Color
    # 值来源
    # ext/curses/curses.c
    BLACK         = Curses::COLOR_BLACK
    RED           = Curses::COLOR_RED
    GREEN         = Curses::COLOR_GREEN
    YELLOW        = Curses::COLOR_YELLOW
    BLUE          = Curses::COLOR_BLUE
    MAGENTA       = Curses::COLOR_MAGENTA
    CYAN          = Curses::COLOR_CYAN
    WHITE         = Curses::COLOR_WHITE
  end
  

  class << self
    def init_screen
      # Todo 提供不同的初始化
      Curses.init_screen
      Curses.cbreak
      Curses.noecho
      Curses.curs_set(0)  # Invisible cursor
      Curses.stdscr.keypad = true
      Curses.start_color
    end

    def init_window
      Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
    end

    def refresh
      Curses.refresh
    end

    def hold
      while true
        sleep 1
      end
    end
  end

  class Widget
    class Text
      ConfigEnum = Struct.new(:color, :bg_color, :font_style)
      DefaultConfig = ConfigEnum.new('white', 'black', 'normal')

      def initialize(window = nil, content = nil)
        @window = window
        @content = content
        
        @color = DefaultConfig.color
        @bg_color = DefaultConfig.bg_color
        @font_style = DefaultConfig.font_style
      end

      def mount(window)
        @window = window
      end


      def styles(opt = {})
        @color = opt[:color]
        @bg_color = opt[:bg_color]
        @font_style = opt[:font_style]
      end


      def render
        # Setting attributes

        ## Origin Curses Example:
        # curses 内部使用了二进制比特位置来代表字体颜色信息
        # ```ruby
        # Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_BLUE, Curses::COLOR_GREEN)
        # Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_RED, Curses::COLOR_WHITE)

        # Curses.attron(Curses.color_pair(Curses::COLOR_RED)) do
        #   Curses.addstr("example")
        # end
        # ```

        font_color = ::Module.const_get("Tui::Color::#{@color.to_s.upcase}")
        bg_color = ::Module.const_get("Tui::Color::#{@bg_color.to_s.upcase}")
        font_style = ::Module.const_get("Tui::FontStyle::#{@font_style.to_s.upcase}")
        Curses.init_pair(font_color, font_color, bg_color)
        

        # Render
        @window.attron(Curses.color_pair(font_color)|font_style) do
          @window.addstr(@content)
        end
      end
    end
  end
end

Tui.init_screen
window = Tui.init_window

b = Tui::Widget::Text.new(window, "Hello World")
b.styles({color: 'green', bg_color: 'green', font_style: 'bold'})
b.render

d = Tui::Widget::Text.new(window, "width is10")
d.styles({color: 'blue', bg_color: 'red', font_style: 'blink'})
d.render


window.refresh

while true
  sleep 1
end
# Tui.hold