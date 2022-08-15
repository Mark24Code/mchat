require 'pathname'

module Mchat
  module UserConfig
    CONFIG_DIR = Pathname.new(Dir.home).join('.mchat')
    CONFIG_PATH = Pathname.new(Dir.home).join('.mchat').join('mchatrc')
    def user_config_exist?
      File.exist? CONFIG_PATH
    end
    def create_user_config
      require 'fileutils'
      FileUtils.mkdir_p(CONFIG_DIR) unless File.exist?(CONFIG_DIR)
      File.open(CONFIG_PATH, 'w') do |f|
init_config = %Q(
# Mchat user config
# use yaml syntax

wait_prefix: ">>"
display_welcome: true
clear_repl_everytime: true
server: "localhost:4567"

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

    def first_time_use
      if !user_config_exist?
        read_user_config
        puts "Mchat first run TIPS".style.jade
        puts ""
        puts "Mchat not found user config, maybe this is your first time run Mchat."
        init_config = "~/.mchat".style.warn
        puts "Mchat has help your create config to #{init_config}"
        server_field = "<server> field".style.warn
        puts "Before you run mchat, edit your config file, change #{server_field} to yours:"
        puts "vim #{CONFIG_PATH.to_s}".style.warn
        puts "make sure your server works, before run Mchat. :D"

        exit 0
      end
    end
  end
end
