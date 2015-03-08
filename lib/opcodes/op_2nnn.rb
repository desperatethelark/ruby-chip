# call subroutine at nnn
class Op2NNN < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter:  nnn,
      stack:            vm[:stack] + [vm[:program_counter]]
    }
  end
end
