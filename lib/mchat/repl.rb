class MchatRepl

  def command_channel
    puts "command_channel"
  end

  def command_help(name,subject = nil)
    puts "command_help: #{subject}"
  end

  def command_quit
    puts "Bye :D"
    # TODO exit life cycle
    exit 0
  end

  def command_message(words)
    puts "[message]" +  words
  end

  def command_default(words)
    puts "[default]" +  words
  end

  def dispatcher(name, content = nil)
    __send__("command_#{name}", content)
  end

  def parser(raw)
    words = raw.strip
    case words
    when '/help', '/h'
      dispatcher('help', nil)
    when /^\/help\s{1}(.*)/, /^\/h\s{1}(.*)/
      puts "<222 #{$1}"
      subject = $1
      dispatcher('help', subject)
    # when /^\/channel\s{1}(.*)/, /^\/ch\s{1}(.*)/
    #   dispatcher('channel', $1)
    # when /^\/message\s{1}(.*)/, /^\/msg\s{1}(.*)/
    #   dispatcher('message', $1)
    # when '/leave','/quit','/exit', '/q'
    #   dispatcher('exit')
    else
      dispatcher('default', words)
    end
  end

  def run
    while true
      printf "[you]"
      typein = gets
      puts "===[debug+]==="
      p typein
      puts "===[debug-]==="
      # system('clear')
      parser(typein)
      sleep 0.1
    end
  end
end

MchatRepl.new.run
