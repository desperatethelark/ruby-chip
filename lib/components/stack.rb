# used to store return addresses when subroutines are called
class Stack < RubyChip::Component
  def self.default_state
    []
  end

  def [](key)
    @state[key]
  end
end
