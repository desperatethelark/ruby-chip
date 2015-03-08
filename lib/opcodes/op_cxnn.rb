# set vx to random number & nn
class OpCXNN < RubyChip::Instruction
  def changes_from_execution
    {
      register: {
        x => rand(0xFF) & nn
      }
    }
  end
end
