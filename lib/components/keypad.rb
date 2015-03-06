class RubyChip::Keypad < RubyChip::Component
  def self.from_default
    RubyChip::Keypad.new Array.new(16, 0)
  end

  def state= new_state
    @state.merge! Hash[new_state]
  end
end