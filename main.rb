require 'gosu'
require 'yaml'

class RubyChip < Gosu::Window
  WIDTH         = 64
  HEIGHT        = 32
  SCALE         = 10
  FULLSCREEN    = false
  MEMORY_START  = 0x200

  def initialize
    load("programs/#{ARGV[0]}")
    super scale(WIDTH), scale(HEIGHT), FULLSCREEN
  end

  def update
    get_user_input
    
    instruction = @op_map.lookup("%04X" % @vm.current_instruction)
    instruction.vm = @vm
    instruction.execute.each do |component, state|
      @vm[component] = state
    end
    
    print "\a" if @vm[:sound_timer] == 1
    @vm[:sound_timer] = [0, @vm[:sound_timer] - 1].max
    @vm[:delay_timer] = [0, @vm[:delay_timer] - 1].max
  end

  def needs_redraw?
    @vm[:draw_flag]
  end

  def draw
    # @vm[:graphics].each {|k,v| p v.join }
    Array(0..WIDTH).product(Array(0..HEIGHT)).each do |x, y|
      color = @vm.graphics.at_xy(x, y) == 1
      quad scale(x), scale(y), scale(x + 1), scale(y + 1), color: color
    end
    
    @vm[:draw_flag] = false
  end

  def get_user_input
    @key_map.map.each { |id, i| @vm[:keypad][i] = button_down?(id) ? 1 : 0 }
  end

  def load program
    @vm = RubyChip::VirtualMachine.new YAML.load_file('config/components.yml')
    @op_map = RubyChip::OpcodeMap.new YAML.load_file('config/opcodes.yml')
    @key_map = RubyChip::KeypadMap.new YAML.load_file('config/keys.yml')

    @vm.memory.load IO.binread(program).unpack("C*")
  end

  def quad x1, y1, x2, y2, options
    color = options[:color] ? Gosu::Color::WHITE : Gosu::Color::BLACK
    draw_quad x1, y1, color, x1, y2, color,
              x2, y2, color, x2, y1, color
  end

  def scale n
    n * SCALE
  end
end

Dir['lib/*.rb'].each { |rb| require_relative rb }
Dir['lib/*/*.rb'].each { |rb| require_relative rb }

window = RubyChip.new
window.show