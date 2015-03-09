# skip next instruction if vx == vy
class Op5XY0 < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: conditional_instruction_skip(vx == vy)
    }
  end
end
