class OpFX0A < RubyChip::Instruction
  def set_vx_to_key_press_if_any
    if (keypress = (0..15).find { |i| vm[:keypad][i] != 0 })
      update_vx keypress
    else
      update program_counter: vm[:program_counter]
    end
  end

  alias_method :execute, :set_vx_to_key_press_if_any
end