# set vx to vy
class Op8XY0 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vy
      }
    }
  end
end
