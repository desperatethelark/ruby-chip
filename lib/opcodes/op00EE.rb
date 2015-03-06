class Op00EE < RubyChip::Instruction
  def return_from_subroutine
    update stack: vm[:stack][0...-1], program_counter: vm[:stack][-1] + 2
  end

  alias_method :execute, :return_from_subroutine
end