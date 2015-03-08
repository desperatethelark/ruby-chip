# set index to nnn
class OpANNN < RubyChip::Instruction
  def changes_from_execution
    {
      index: nnn
    }
  end
end
