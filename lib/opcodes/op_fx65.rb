# fill registers v0-vx with memory starting at i
class OpFX65 < RubyChip::Instruction
  def changes_from_execution
    {
      register: (0..x).map { |v| [v, vm.memory.at(i + v)] }
    }
  end
end
