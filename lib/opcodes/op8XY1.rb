class Op8XY1 < RubyChip::Instruction
  def set_vx_to_vx_OR_vy
    update_vx vx | vy
  end

  alias_method :execute, :set_vx_to_vx_OR_vy
end