# skip next instruction if key vx is not pressed
class OpEXA1 < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: conditional_instruction_skip(vm[:keypad][vx] == 0)
    }
  end
end
