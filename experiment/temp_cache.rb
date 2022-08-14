require 'tempfile'

class TempCache
  attr_accessor :temp_file
  def initialize
    @temp_file = nil
    @temp_file_path = nil
  end

  def get_temp_file
    if !@temp_file
      @temp_file = Tempfile.new
      @temp_file_path = @temp_file.path
    end
  end

  def write(content)
    get_temp_file

    begin
      if content.is_a? Array
        content.each do |c|
          @temp_file << c
        end
      else
        @temp_file << content
      end
    ensure
      close
    end
  end

  def read
    begin
      @temp_file.read
    ensure
      close
    end
  end

  def close
    @temp_file.close
  end

  def unlink
    @temp_file.unlink
  end
end
