class Op8XY2 < RubyChip::Instruction
  def set_vx_to_vx_AND_vy
    update_vx vx & vy
  end

  alias_method :execute, :set_vx_to_vx_AND_vy
end