class RubyChip::Register < RubyChip::Component
  def self.from_default
    RubyChip::Register.new Hash[default_state]
  end

  def self.default_state
    (0...16).map { |n| [n, 0] }
  end

  def state= new_state
    @state.merge! Hash[new_state.map { |k,v| [k, v % 0x100] }]
  end
end