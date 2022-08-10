require './lambda_vnode'
require './hooks'
require './tui'


def m(*opt)
  VNode.m(*opt)
end


blogs, set_blogs = Hook.use_state([
  "Wikis now support math and Mermaid diagrams",
  "Advisory Database supports GitHub Actions advisories",
  "GitHub Actions: Ubuntu 22.04 is now generally available on GitHub-hosted runners",
  "GitHub Actions: The Ubuntu 18.04 Actions runner image is being deprecated and will "
])



tui_text = -> (*opt) {
  content, config = opt
  b = Tui::Widget::Text.new(Window, content)
  b.styles(config)
  b.render
}


tui_demo = -> (app) {
  Tui.init_screen
  Window = Tui.init_window
  VNode::Render.new(app).render
  Window.refresh
  while true
    sleep 1
  end
  # Tui.hold
}


tui_app = -> () {
  return m([
      m(tui_text, "Hello", {color: 'blue', bg_color: 'red', font_style: 'bold'}),
      m(tui_text, "work", {color: 'red', bg_color: 'green'})
    ])
}

tui_demo.call(tui_app)