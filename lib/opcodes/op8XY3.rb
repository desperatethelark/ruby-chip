class Op8XY3 < RubyChip::Instruction
  def set_vx_to_vx_XOR_vy
    update_vx vx ^ vy
  end

  alias_method :execute, :set_vx_to_vx_XOR_vy
end