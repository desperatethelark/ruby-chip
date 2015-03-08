# set delay timer to vx
class OpFX15 < RubyChip::Instruction
  def changes_from_execution
    {
      delay_timer: vx
    }
  end
end
