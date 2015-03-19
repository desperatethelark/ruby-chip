# store the BCD of vx in memory starting at address i
class OpFX33 < RubyChip::Instruction
  def changes_from_execution
    {
      memory: {
        (i)     => (vx / 100),
        (i + 1) => (vx % 100) / 10,
        (i + 2) => (vx %  10)
      }
    }
  end
end
