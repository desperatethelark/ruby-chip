# set sound timer to vx
class OpFX18 < RubyChip::Instruction
  def changes_from_execution
    {
      sound_timer: vx
    }
  end
end
