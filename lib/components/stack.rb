class RubyChip::Stack < RubyChip::Component

  def self.from_default
    RubyChip::Stack.new default_state
  end

  def self.default_state      
    []
  end

  def [] key
    @state[key]
  end
  
end