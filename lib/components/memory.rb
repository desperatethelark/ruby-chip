# 4096 byte memory; program starts at 0x200
class Memory < RubyChip::Component
  PROGRAM_START = 0x200

  def self.default_state
    Hash[(0...4096).map { |n| [n, fonts[n] || 0] }]
  end

  def bytes_from(state)
    @state[state] << 8 | @state[state + 1]
  end

  def at(i)
    @state[i]
  end

  def state=(new_state)
    @state.merge! Hash[new_state]
  end

  def load(program)
    self.state = program.map.with_index { |byte, i| [PROGRAM_START + i, byte] }
  end

  def self.fonts
    @fonts ||= YAML.load_file('config/fonts.yml')
  end
end
