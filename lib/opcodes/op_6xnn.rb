# set vx to nn
class Op6XNN < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => nn
      }
    }
  end
end
