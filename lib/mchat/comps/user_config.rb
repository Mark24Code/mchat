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
# server: "localhost:4567"

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

    def check_server_before_all
      if !@server
        puts "Mchat about `Server` Tips".style.jade
        puts ""
        init_config = "~/.mchat".style.warn
        puts "Mchat has help your create config to #{init_config}"
        server_field = "<server> field".style.warn
        puts "Before you run mchat, edit your config file, change #{server_field} to yours:"
        puts "vim #{CONFIG_PATH.to_s}".style.warn
        puts "make sure your server works, before run Mchat."
        puts ""
        puts "If you have server address, you can also run like this:"
        puts "mchat --server='http://<your host>'"
        puts "e.g.  mchat --server='http://localhost:4567'"
        puts "so you will not need to edit mchatrc." + " :)".style.warn
        puts ""
        puts "Confirm? (y/yes)"
        while true
          confirm = gets
          confirm = confirm.strip
          if confirm == 'y' || confirm == 'yes'
            system('screen -X quit')
          end
          sleep 0.1
        end
      end
    end
  end
end
