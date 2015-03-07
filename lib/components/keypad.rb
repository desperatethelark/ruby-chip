class RubyChip::Keypad < RubyChip::Component
  def self.from_default
    RubyChip::Keypad.new Array.new(16, 0)
  end

  def [] index
    @state[index]
  end

  def []= index, value
    @state[index] = value
  end
end