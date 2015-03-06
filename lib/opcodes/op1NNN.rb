class Op1NNN < RubyChip::Instruction
  def jump_to_address_nnn
    update program_counter: nnn
  end

  alias_method :execute, :jump_to_address_nnn
end