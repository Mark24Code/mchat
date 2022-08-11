require './lambda_vnode'
require './hooks'
require './tui'

module Tui
  module Component
    def tui_text(*opt) 
      content, config = opt
      b = Tui::Widget::Text.new(content)
      b.styles(config)
      b.render
    end
  end
end