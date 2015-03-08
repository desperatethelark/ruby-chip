module RubyChip
  # superclass of everything in lib/components
  class Component
    attr_accessor :state

    def initialize(state)
      @state = state
    end

    def self.from_default
      new(default_state)
    end
  end
end
