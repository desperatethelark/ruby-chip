class Op00E0 < RubyChip::Instruction
  def clear_screen
    update draw_flag: true, graphics: RubyChip::Graphics.default_state
  end
  
  alias_method :execute, :clear_screen
end