# set vx to vx AND vy
class Op8XY2 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vx & vy
      }
    }
  end
end
