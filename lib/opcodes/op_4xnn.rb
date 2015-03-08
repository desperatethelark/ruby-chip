# skip next instruction if vx != nn
class Op4XNN < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: conditional_instruction_skip(vx != nn)
    }
  end
end
