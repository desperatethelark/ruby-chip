class OpEXA1 < RubyChip::Instruction
  def skip_next_instruction_unless_key_vx_is_pressed
    skip_next_instruction_if vm[:keypad][vx] == 0
  end

  alias_method :execute, :skip_next_instruction_unless_key_vx_is_pressed
end