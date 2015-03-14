# hex keyboard 0-F
class Keypad < RubyChip::Component
  def self.default_state
    Array.new(16, 0)
  end
end
