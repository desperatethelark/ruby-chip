class OpFX07 < RubyChip::Instruction
  def set_vx_to_delay_timer_value
    update_vx vm[:delay_timer]
  end

  alias_method :execute, :set_vx_to_delay_timer_value
end