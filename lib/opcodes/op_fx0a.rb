# await key press and store in vx
class OpFX0A < RubyChip::Instruction
  def changes_from_execution
    if vm[:keypad].index(1)
      {
        register: { x => vm[:keypad].index(1) }
      }
    else
      {
        program_counter: vm[:program_counter]
      }
    end
  end
end
