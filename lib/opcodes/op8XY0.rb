class Op8XY0 < RubyChip::Instruction
  def set_vx_to_vy
    update_vx vy
  end

  alias_method :execute, :set_vx_to_vy
end