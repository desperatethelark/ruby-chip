class OpFX33 < RubyChip::Instruction  
  def store_bcd_of_vx_in_memory_starting_at_i
    update memory: memory
  end

  alias_method :execute, :store_bcd_of_vx_in_memory_starting_at_i

  private

  def memory
    { 
      (i    ) => (vx / 100),
      (i + 1) => (vx / 10) % 10,
      (i + 2) => (vx % 10)
    }
  end
end