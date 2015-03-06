class Op8XYE < RubyChip::Instruction
  def left_shift_vx_and_set_vf_to_vxs_MSB
    update register: registers 
  end

  alias_method :execute, :left_shift_vx_and_set_vf_to_vxs_MSB

  def registers
    { x => vx << 1, f => vx >> 7 }
  end
end