class OpFX65 < RubyChip::Instruction
  def fill_registers_with_memory
    update register: registers, index: i + x + 1
  end

  alias_method :execute, :fill_registers_with_memory

  private

  def registers
    (0..x).map { |v| [v, vm.memory.at(i + v)] }
  end
end