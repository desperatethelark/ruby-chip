# set vx to vy - vx. if there is a borrow, set vf to 0, otherwise set it to 1
class Op8XY7 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        f => bitmap(vy >= vx),
        x => vy - vx
      }
    }
  end
end
