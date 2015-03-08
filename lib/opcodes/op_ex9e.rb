# skip next instruction if key vx is pressed
class OpEX9E < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: conditional_instruction_skip(vm[:keypad][vx] != 0)
    }
  end
end
