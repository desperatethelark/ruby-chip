class OpANNN < RubyChip::Instruction
  def set_index_to_nnn
    update index: nnn
  end

  alias_method :execute, :set_index_to_nnn
end