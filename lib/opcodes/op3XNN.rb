class Op3XNN < RubyChip::Instruction
  def skip_next_instruction_if_vx_eq_nn
    skip_next_instruction_if vx == nn
  end

  alias_method :execute, :skip_next_instruction_if_vx_eq_nn
end