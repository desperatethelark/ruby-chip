class RubyChip::ProgramCounter < RubyChip::Component
  def self.from_default
    RubyChip::ProgramCounter.new 0x200
  end

  def state= new_state
    @state = new_state % 0x1000
  end
end