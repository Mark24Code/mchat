require './lambda_vnode'
require './hooks'
require './tui'
require './tui_widgets'



blogs, set_blogs = Hook.use_state([
  "Wikis now support math and Mermaid diagrams",
  "Advisory Database supports GitHub Actions advisories",
  "GitHub Actions: Ubuntu 22.04 is now generally available on GitHub-hosted runners",
  "GitHub Actions: The Ubuntu 18.04 Actions runner image is being deprecated and will "
])



# tui_text = -> (*opt) {
#   content, config = opt
#   b = Tui::Widget::Text.new(content)
#   b.styles(config)
#   b.render
# }




# 提供一个洁净室
runspace = Object.new
runspace.extend Tui::Component

runspace.instance_eval {

  application = -> (app) {
    Tui.init_window
    VNode::Render.new(app).render
    Tui.window.refresh
    while true
      sleep 1
    end
    # Tui.hold
  }

  tui_component = method(:tui_text).to_proc

  # 这里的问题是
  # 如果m的头字母是lambda其实是这个上下文中的lambda直接使用，相当于传递了变量
  # 如果想要聚合的组件库，这需要m可以在上下文中搜索
  # 关于搜索这件事情，关于 def
  # 要么是实例上下文
  # 要么是class上下文
  # 这些上下文都在当前环境中，但是m的计算是m内部的，对m来说不公开，所以找不到
  # 方法1
  # 可以在当前上下文中嵌入lambda引用变量
  # （但是这个对有要求，需要封装成类方法）
  # tui_text = -> () {
  #   Tui::Component.tui_text
  # }
  # 方法2 x
  # extend 到实例上下文
  # 用变量返回变量| 这里问题是一旦方法这样写就被执行了
  # 所以无法引用当前的实例方法
  # tui_component = -> () {
  #   :tui_text
  # }

  # 方法3 method只能返回 Method 类型
  # 需要 to_proc 返回
  # 返回这样可以工作
  # tui_component = method(:tui_text).to_proc

  tui_app = -> () {
    return m([
        m(tui_component, "Hello", {color: 'blue', bg_color: 'red', font_style: 'bold'}),
        m(tui_component, "work", {color: 'red', bg_color: 'green'})
      ])
  }

  application.call(tui_app)

}