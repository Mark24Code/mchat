module VNode
  def self.m(name = 'text', opts = {}, elements)
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
        return method(name).call
      end

      if name.instance_of? Proc
        return name.call
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
