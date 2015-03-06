class OpFX15 < RubyChip::Instruction
  def set_delay_timer_to_vx
    update delay_timer: vx
  end

  alias_method :execute, :set_delay_timer_to_vx
end