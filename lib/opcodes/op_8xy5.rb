# set vx to vx - vy; if there is a borrow, set vf to 0, otherwise set it to 1
class Op8XY5 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        f => bitmap(vx > vy),
        x => vx - vy
      }
    }
  end
end
