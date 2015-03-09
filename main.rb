require_relative './ruby_chip'

# Gosu window for running the game loop and rendering
class Window < Gosu::Window
  def initialize
    super scale(RubyChip::WIDTH), scale(RubyChip::HEIGHT), fullscreen = false
    self.caption = "RubyChip - #{ARGV[0]}"

    load("programs/#{ARGV[0]}")
  end

  def update
    update_user_input
    update_vm_state
    check_for_sound_cue
    update_timers
  end

  def needs_redraw?
    @vm[:draw_flag]
  end

  def draw
    Array(0..RubyChip::WIDTH).product(Array(0..RubyChip::HEIGHT)).each do |x, y|
      quad scale(x), scale(y), scale(x + 1), scale(y + 1), color(x, y)
    end

    @vm[:draw_flag] = false
  end

  # initialize helpers

  def load(program)
    @vm = RubyChip::VirtualMachine.new yaml('config/components.yml')
    @op_map = RubyChip::OpcodeMap.new yaml('config/opcodes.yml'), @vm
    @key_map = RubyChip::KeypadMap.new yaml('config/keys.yml')

    @vm.memory.load IO.binread(program).unpack('C*')
  end

  def yaml(file)
    YAML.load_file file
  end

  # update helpers

  def update_user_input
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

  # draw helpers

  def quad(x1, y1, x2, y2, color)
    draw_quad x1, y1, color, x1, y2, color, x2, y2, color, x2, y1, color
  end

  def color(x, y)
    @vm.graphics.at_xy(x, y) == 1 ? Gosu::Color::WHITE : Gosu::Color::BLACK
  end

  def scale(n)
    n * RubyChip::SCALE
  end
end

window = Window.new
window.show
