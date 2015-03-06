class OpFX18 < RubyChip::Instruction
  def set_sound_timer_to_vx
    update sound_timer: vx
  end

  alias_method :execute, :set_sound_timer_to_vx
end