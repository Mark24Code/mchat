# virtual node/dom implement
module VNode
  class Component
    # VNode node
    # Example
    #
    # ```ruby
    # class App < VNode::Component
    #   def initialize
    #     super
    #   end

    #   def render
    #     m([
    #       m("hello"),
    #       m("world"),
    #       m(A, { name:"Component"}, nil),
    #       m([
    #         m(
    #           [
    #             m("ruby"),
    #             m("Python")
    #           ]),
    #         m("lang")
    #       ]),
    #     ])
    #   end
    # end
    # ```
    attr :id
    def initialize(opt={})
      @id = "node_"+Time.now.to_i.to_s
    end

    def render
      # template
    end

    def m(name = 'text', opts = {}, elements)
      if elements.instance_of? Array
        return elements.map do |element|
          # m expression
          element
        end
      else
        if name == 'text'
          # content
          # TODO 一个带有属性的节点
          return elements
        end

        # 自定义Component类，约定运行 view
        if name.instance_of? Class
          return name.new(opts).render
        end
      end
    end
  end


  class Render
    def initialize(root_cls)
      @root = root_cls.new
    end

    def render
      puts @root.render
    end
  end
end


class UserName < VNode::Component
  def initialize(opt)
    super
    @name = opt[:name]
  end
  def render
    return m("text","UserName:"+ @name)
  end
end


class App < VNode::Component
  def initialize
    super
  end

  def render
    m([
      m("hello"),
      m("world"),
      m(UserName, { name:"mark24"}, nil),
      m([
        m(
          [
            m("ruby"),
            m("Python")
          ]),
        m("lang")
      ]),
    ])
  end
end

application = VNode::Render.new(App)

application.render
application.render

# TODO
# 更新的api + 任务队列，可供外部调用
# 实现一个 Curses 对应的 Component Adapter
# Vnode和Component实现分离开
