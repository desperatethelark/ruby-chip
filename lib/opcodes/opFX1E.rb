class OpFX1E < RubyChip::Instruction
  def add_vx_to_i
    update index: i + vx, register: range_overflow?
  end

  alias_method :execute, :add_vx_to_i

  private

  def range_overflow?
    { f => bitmap(i + vx > 0xFFF) }
  end
end