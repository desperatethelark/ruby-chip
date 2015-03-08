# await key press and store in vx
class OpFX0A < RubyChip::Instruction
  def changes_from_execution
    if (keypress = (0...16).find { |key| vm[:keypad][key] != 0 })
      {
        register: { x => keypress }
      }
    else
      {
        program_counter: vm[:program_counter]
      }
    end
  end
end
