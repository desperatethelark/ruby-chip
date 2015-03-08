# set vx to delay timer
class OpFX07 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vm[:delay_timer]
      }
    }
  end
end
