# set i to the sprite at vx
class OpFX29 < RubyChip::Instruction
  def changes_from_execution
    {
      index: vx * 0x5
    }
  end
end
