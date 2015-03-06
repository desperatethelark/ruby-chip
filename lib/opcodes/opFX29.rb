class OpFX29 < RubyChip::Instruction
  def set_i_to_vx_sprite
    update index: vx * 0x5
  end

  alias_method :execute, :set_i_to_vx_sprite
end