# jump to address nnn + v0
class OpBNNN < RubyChip::Instruction
  def changes_from_execution
    {
      program_counter: nnn + v0
    }
  end
end
