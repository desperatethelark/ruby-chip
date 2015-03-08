# set vx to vx + nn
class Op7XNN < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => vx + nn
      }
    }
  end
end
