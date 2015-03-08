# set index to i + vx; set vf to 1 if the result is out of range, otherwise 0
class OpFX1E < RubyChip::Instruction
  def changes_from_execution
    {
      index: i + vx,
      register: {
        f => bitmap(i + vx > 0xFFF)
      }
    }
  end
end
