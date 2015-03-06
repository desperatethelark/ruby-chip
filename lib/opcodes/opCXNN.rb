class OpCXNN < RubyChip::Instruction
  def set_vx_to_random_number_masked_by_nn
    update_vx rand(0xFF) & nn
  end

  alias_method :execute, :set_vx_to_random_number_masked_by_nn
end