# store the MSB of vx in vf and left shift vx by 1
class Op8XYE < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        f => vx & 0x80,
        x => vx << 1
      }
    }
  end
end
