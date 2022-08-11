require './eventloop'



class MchatRepl
  def initialize
    @evtloop = EventLoop.new
  end



  def repl_core
    @evtloop.task do




    end
  end
  def run
    repl_core
    @evtloop.start
  end
end
