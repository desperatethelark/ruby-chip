# 16 8-bit data registers V0-VF
class Register < RubyChip::Component
  def self.default_state
    Hash[(0...16).map { |n| [n, 0] }]
  end

  def state=(new_state)
    @state.merge! Hash[new_state.map { |k, v| [k, v % 0x100] }]
  end
end
