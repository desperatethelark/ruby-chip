# set vx to vx XOR vy
class Op8XY3 < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vx ^ vy
      }
    }
  end
end
