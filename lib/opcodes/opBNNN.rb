class OpBNNN < RubyChip::Instruction
  def jump_program_to_nnn_plus_v0
    update program_counter: nnn + v0
  end

  alias_method :execute, :jump_program_to_nnn_plus_v0
end