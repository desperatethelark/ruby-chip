# fill memory with registers v0-vx
class OpFX55 < RubyChip::Instruction
  def changes_from_execution
    {
      index:  i + x + 1,
      memory: (0..x).map { |v| [i + v, vm[:register][v]] }
    }
  end
end
