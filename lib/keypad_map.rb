class RubyChip::KeypadMap
  attr_reader :map

  def initialize key_mappings
    @map = Hash[key_mappings.map { |const, i| [Object.const_get(const), i] }]
  end

  def lookup const
    @map[const]
  end
end