# set vx to vx OR vy
class Op8XY1 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vx | vy
      }
    }
  end
end
