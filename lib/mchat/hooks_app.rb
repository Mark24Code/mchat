require './lambda_vnode'
require './hooks'
require './tui'



blogs, set_blogs = Hook.use_state([
  "Wikis now support math and Mermaid diagrams",
  "Advisory Database supports GitHub Actions advisories",
  "GitHub Actions: Ubuntu 22.04 is now generally available on GitHub-hosted runners",
  "GitHub Actions: The Ubuntu 18.04 Actions runner image is being deprecated and will "
])



tui_text = -> (*opt) {
  content, config = opt
  b = Tui::Widget::Text.new(content)
  b.styles(config)
  b.render
}


application = -> (app) {
  Tui.init_window
  VNode::Render.new(app).render
  Tui.window.refresh
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

application.call(tui_app)