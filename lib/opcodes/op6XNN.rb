class Op6XNN < RubyChip::Instruction
  def set_vx_to_nn
    update_vx nn
  end

  alias_method :execute, :set_vx_to_nn
end