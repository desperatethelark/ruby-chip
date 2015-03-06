class Op8XY4 < RubyChip::Instruction
  def add_vy_to_vx_and_set_carry_flag_on_vf
    update register: registers
  end

  alias_method :execute, :add_vy_to_vx_and_set_carry_flag_on_vf

  def registers
    { x => vx + vy, f => bitmap(vy + vy > 0xFF) }
  end
end