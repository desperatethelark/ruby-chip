class Op8XY6 < RubyChip::Instruction
  def right_shift_vx_and_set_vf_to_vxs_LSB
    update register: registers
  end

  alias_method :execute, :right_shift_vx_and_set_vf_to_vxs_LSB

  def registers
    { x => vx >> 1, f => vx & 0x1 }
  end
end