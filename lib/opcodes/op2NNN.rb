class Op2NNN < RubyChip::Instruction
  def call_subroutine_at_nnn
    update program_counter: nnn, stack: vm[:stack] + [vm[:program_counter]]
  end

  alias_method :execute, :call_subroutine_at_nnn
end