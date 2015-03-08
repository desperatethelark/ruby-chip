# return from subroutine
class Op00EE < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter:  vm[:stack].last + 2,
      stack:            vm[:stack][0...-1]
    }
  end
end
