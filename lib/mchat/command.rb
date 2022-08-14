module Mchat
  module Command
    # Class ########################3
    CommandComps = {}
    CommandConditions = []

    def self.mount_command(name, mod)
      CommandComps[name] = mod
    end

    def self.load_command(name)
      h = CommandComps
      unless cmd = h[name]
        require_relative "./commands/#{name}"
        raise RodaError, "command #{name} did not mount itself correctly in Mchat::Command" unless cmd = h[name]
      end
      cmd
    end

    def self.install(cmd, *args, &block)
      cmd = Mchat::Command.load_command(cmd) if cmd.is_a?(Symbol)
      raise MchatError, "Invalid cmd type: #{cmd.class.inspect}" unless cmd.is_a?(Module)

      include(cmd::InstanceMethods) if defined?(cmd::InstanceMethods)
      extend(cmd::ClassMethods) if defined?(cmd::ClassMethods)
      cmd.configure(self, *args, &block) if cmd.respond_to?(:configure)
    end
  end
end
