module VNode
  def self.m(*opt)
    # opt is array
    name = nil
    config = {}
    elements = nil

    if opt.length == 0
      throw Exception("VNode.m need at least one argument")
    end

    if opt.length == 1
      el = opt.first

      if el.instance_of? String
        name = "text"
        elements = opt.first
      end

      if el.instance_of? Proc
        name = el
      end

      if el.instance_of? Array
        name = 'array'
        elements = el
      end
    end

    if opt.length == 2
      left = opt.first
      if left.instance_of? String
        name, elements = opt
      end

      if left.instance_of? Proc
        name, config = opt
        elements = nil
      end
    end

    if opt.length === 3
      name, config, elements = opt
    end

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
      # if name.instance_of? Class
      #   return name.new(opts).render
      # end

      # 对函数式组件支持
      if name.instance_of? Symbol
        return method(name).call(config)
      end

      if name.instance_of? Proc
        return config=={} ? name.call : name.call(config)
      end
    end
  end

  class Render
    def initialize(root)
      @root = root
    end

    def render
      puts @root.call
    end
  end
end
