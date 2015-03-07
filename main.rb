require 'gosu'
require 'yaml'

class RubyChip < Gosu::Window
  WIDTH         = 64
  HEIGHT        = 32
  SCALE         = 10
  FULLSCREEN    = false

  def initialize
    super scale(WIDTH), scale(HEIGHT), FULLSCREEN
    self.caption = "RubyChip - #{ARGV[0]}"

    load("programs/#{ARGV[0]}")
  end

  def update
    get_user_input
    update_vm_state
    check_for_sound_cue
    update_timers
  end

  def needs_redraw?
    @vm[:draw_flag]
  end

  def draw
    Array(0..WIDTH).product(Array(0..HEIGHT)).each do |x, y|
      color = @vm.graphics.at_xy(x, y) == 1
      quad scale(x), scale(y), scale(x + 1), scale(y + 1), color: color
    end
    
    @vm[:draw_flag] = false
  end

  def get_user_input
    @key_map.map.each { |id, i| @vm.keypad[i] = button_down?(id) ? 1 : 0 }
  end

  def update_vm_state
    @op_map.lookup(@vm.opcode).execute.each { |comp, val| @vm[comp] = val }
  end

  def check_for_sound_cue
    print "\a" if @vm[:sound_timer] == 1
  end

  def update_timers
    [:delay_timer, :sound_timer].each { |t| @vm[t] = [@vm[t] - 1, 0].max }
  end

  def load program
    @vm = RubyChip::VirtualMachine.new YAML.load_file('config/components.yml')
    @op_map = RubyChip::OpcodeMap.new YAML.load_file('config/opcodes.yml'), @vm
    @key_map = RubyChip::KeypadMap.new YAML.load_file('config/keys.yml')

    @vm.memory.load IO.binread(program).unpack("C*")
  end

  def quad x1, y1, x2, y2, options
    color = options[:color] ? Gosu::Color::WHITE : Gosu::Color::BLACK
    draw_quad x1, y1, color, x1, y2, color, x2, y2, color, x2, y1, color
  end

  def scale n
    n * SCALE
  end
end

Dir['lib/*.rb'].each { |rb| require_relative rb }
Dir['lib/*/*.rb'].each { |rb| require_relative rb }

window = RubyChip.new
window.show