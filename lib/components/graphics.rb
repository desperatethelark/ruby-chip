class RubyChip::Graphics < RubyChip::Component
  def self.from_default    
    RubyChip::Graphics.new Hash[default_state]
  end

  def state= new_state
    @state.merge! Hash[new_state]
  end

  def self.default_state
    (0...2048).map { |n| [n, 0] }
  end

  def at_xy x, y
    @state[address_for x, y]
  end

  def at_address address
    @state[address]
  end

  def address_for x, y
    x + y * RubyChip::WIDTH
  end
end