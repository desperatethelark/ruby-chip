# jump to address nnn
class Op1NNN < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: nnn
    }
  end
end
