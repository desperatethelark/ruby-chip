class Op8XY5 < RubyChip::Instruction
  def subtract_vy_from_vx_and_set_borrow_flag_on_vf
    update register: registers
  end

  alias_method :execute, :subtract_vy_from_vx_and_set_borrow_flag_on_vf

  def registers
    { x => vx - vy, f => bitmap(vx - vy > 0) }
  end
end