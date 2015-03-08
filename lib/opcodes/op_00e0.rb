# clear the screen
class Op00E0 < RubyChip::Instruction
  def changes_from_execution
    {
      draw_flag:  true,
      graphics:   Graphics.default_state
    }
  end
end
