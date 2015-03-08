# set vx to vx + vy; if there is a carry, set vf to 1, otherwise set it to 0
class Op8XY4 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        f => bitmap(vy + vy > 0xFF),
        x => vx + vy
      }
    }
  end
end
