# store the LSB of vx in vf and right shift vx by 1
class Op8XY6 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        f => vx & 0x01,
        x => vx >> 1
      }
    }
  end
end
