class Op9XY0 < RubyChip::Instruction
  def skip_next_instruction_unless_vx_eq_vy
    skip_next_instruction_if vx != vy
  end

  alias_method :execute, :skip_next_instruction_unless_vx_eq_vy
end