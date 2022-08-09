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

    def refresh
      Curses.refresh
    end

    def hold
      while true
        sleep 1
      end
    end
  end

  class Box
    # 模仿盒模型
    # * 具有 对齐
    # * 具有颜色

    # 定位是放在 window里面一行
    # 类似 block\inline-block 
    # 简化每次伴随attr设置

    def initialize(window = nil, content = nil)
      @window = window
      @content = content
      @attr = nil
    end

    def mount(window)
      @window = window
    end

    # def bak_render(row,col)
    #   result = "#{content}" + " " * (@window_width - content.length)


    #   @window.setpos(row, col)
    #   # Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_BLUE, Curses::COLOR_GREEN)
    #   @window.attron(Curses.color_pair(Curses::COLOR_BLUE)) do
    #     @window.addstr(result)
    #   end
    # end


    def styles(opt = {})
      @color = opt[:color] || 'white'
      @bg_color = opt[:bg_color] || 'black'
      @font_style = opt[:font_style] || 'normal'

      @display = opt[:display] || 'block' # block / inline
      @text_align = opt[:text_align] || 'left' # left center right

      @width = opt[:width] || nil # || @window.cols
      @height = opt[:height] || nil #|| @window.lines
      
      if @display == 'block' && @width == nil
        @width = @window.cols
      end

      if @display == 'inline' && @width == nil
        @width = @content.length
      end
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
      
      
      # Setting formating
      # Render
      result = nil

      if @content.length < @width
        if @text_align == 'left'
          result = @content + " " * (@width - @content.length)
        end
        if @text_align == 'right'
          result = " " * (@width - @content.length) + @content 
        end

        if @text_align == 'center'
          left_gap = (@width - @content.length)/2 
          right_gap = @width - @content.length - left_gap
          result = " " * left_gap + @content + " " * right_gap
        end
      end

      if @content.length == @width
        result = @content
      end

      if @content.length > @width
        result = @content[0 .. @width-1]
      end

      @window.attron(Curses.color_pair(font_color)|font_style) do
        @window.addstr(result)
      end
    end
  end
end

Tui.init_screen

b = Tui::Box.new(Curses, "Hello World")
b.styles({color: 'green', bg_color: 'green', font_style: 'bold', display: 'block'})
b.render

c = Tui::Box.new(Curses, "example")
c.styles({color: 'red', bg_color: 'white', font_style: 'blink', display: 'inline'})
c.render

Tui.refresh
Tui.hold