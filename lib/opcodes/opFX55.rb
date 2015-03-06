class OpFX55 < RubyChip::Instruction
  def fill_memory_with_registers
    update memory: memory, index: vm[:index] + i + 1
  end

  alias_method :execute, :fill_memory_with_registers

  private
  
  def memory
    (0..x).map { |v| [ i + v, vm[:register][i] ] }
  end
end