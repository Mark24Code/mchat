

module Hook
  State = Struct.new(:state_id, :value)

  class StoreHook

    def gen_id
      Time.now.to_i
    end

    attr_accessor :store, :update
    def initialize
      @store = {}
      @update = []
    end

    def use_state(value)
      state_id = "state_id:#{self.gen_id}"
      state = State.new(state_id, value)
      @store[state_id] = state

      state_setter = lambda { |value|
        # 保持引用赋值，不可切断
        @store[state.state_id].value = value
        @update.push(state.state_id)
      }

      # 首参数保持引用，基本值会值复制传参，所以得保持引用
      return [@store[state_id], state_setter ]
    end
  end

  class << self
    Store = StoreHook.new

    def use_state(opt)
      return Store.use_state(opt)
    end
  end
end
# Example
# ```ruby
# store =  StoreHook.new
# name, set_name = store.use_state("mark24")

# _puts name.value
# set_name.call("linda")
# _puts name.value
# ```
