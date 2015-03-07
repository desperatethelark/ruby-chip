class RubyChip::Memory < RubyChip::Component
  PROGRAM_START = 512

  def self.from_default
    RubyChip::Memory.new Hash[default_state]
  end

  def self.default_state
    (0...4096).map {|n| [n, fonts[n] || 0] }
  end

  def [] key
    @state[key]
  end

  def bytes_from(state)
    @state[state] << 8 | @state[state + 1]
  end

  def at i
    @state[i]
  end

  def state= new_state
    @state.merge! Hash[new_state]
  end

  def load program
    self.state = program.map.with_index { |byte, i| [PROGRAM_START + i, byte] }
  end

  def self.fonts
    @@fonts ||= YAML.load_file('config/fonts.yml')
  end  
end