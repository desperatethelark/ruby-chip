class Op7XNN < RubyChip::Instruction
  def add_nn_to_vx
    update_vx vx + nn
  end

  alias_method :execute, :add_nn_to_vx
end