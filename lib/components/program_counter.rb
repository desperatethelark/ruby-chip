class RubyChip::ProgramCounter < RubyChip::Component
  def self.from_default
    RubyChip::ProgramCounter.new 0x200
  end
end