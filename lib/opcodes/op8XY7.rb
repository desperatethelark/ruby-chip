class Op8XY7 < RubyChip::Instruction
  def set_vx_to_vy_minus_vx_and_set_borrow_flag_on_vf
    update register: registers
  end

  alias_method :execute, :set_vx_to_vy_minus_vx_and_set_borrow_flag_on_vf

  def registers
    { x => vy - vx, f => bitmap(vy - vx > 0) }
  end
end