require 'pathname'

module Mchat
  module UserConfig
    CONFIG_PATH = Pathname.new(Dir.home).join('.mchatrc')
    def user_config_exist?
      File.exist? CONFIG_PATH
    end
    def create_user_config
      File.open(CONFIG_PATH, 'w') do |f|
init_config = %Q(
# Mchat user config
# use yaml syntax

wait_prefix: ">>"
display_welcome: true
clear_repl_everytime: true

)
      f << init_config
      end
    end

    def read_user_config
      if !user_config_exist?
        create_user_config
      end

      require 'yaml'
      opt = YAML.load(File.open(CONFIG_PATH))
      return opt
    end
  end
end
