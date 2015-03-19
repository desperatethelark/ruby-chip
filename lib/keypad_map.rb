module RubyChip
  # lookup table for key bindings
  class KeypadMap
    attr_reader :keys

    def initialize(key_mappings)
      @keys = Hash[key_mappings.map { |const, i| [Object.const_get(const), i] }]
    end
  end
end
