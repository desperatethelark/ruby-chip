# for keeping track of the current program instruction to be executed
class ProgramCounter < RubyChip::Component
  def self.default_state
    0x200
  end

  def state=(new_state)
    @state = new_state % 0x1000
  end
end
