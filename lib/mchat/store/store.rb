require 'pathname'
require 'pstore'

module Mchat
  module Store
    module Config
      STORE_PATH = Pathname.new(Dir.home).join('mchatdb')
      def store_exist?
        File.exist? STORE_PATH
      end
      def create_store
        PStore.new(STORE_PATH)
      end

      def get_store
        if !store_exist?
          create_store
        end

        store = ::PStore.new(STORE_PATH)
        return store
      end
    end
  end
end
