# fill memory with registers v0-vx
class OpFX55 < RubyChip::Instruction
  def changes_from_execution
    {
      memory: (0..x).map { |v| [i + v, vm[:register][v]] }
    }
  end
end
