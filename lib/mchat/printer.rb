module MiniChat

  class Printer
    def initialize(output)
      @output = output
    end

    def display(content)
      if content.instance_of? String
        content = [content]
      end

      if content.instance_of? Array
        write_to(content)
      end
    end

    def write_to(content_arr)
      File.open(@output, 'w+') do |f|
        content_arr.each { |line| f << "#{line}" }
      end
    end
  end
end

