require_relative './ruby_chip'

# Gosu window for running the game loop and rendering
class Window < Gosu::Window
  WIDTH  = RubyChip::WIDTH  * RubyChip::SCALE
  HEIGHT = RubyChip::HEIGHT * RubyChip::SCALE
  FULLSCREEN = true
  SPEED = 10

  def initialize
    super(WIDTH, HEIGHT, FULLSCREEN)
    self.caption = "RubyChip - #{ARGV[0]}"
    @sound = Gosu::Song.new(self, 'sound.wav')
    load("programs/#{ARGV[0]}")
  end

  def update
    SPEED.times do
      update_user_input
      update_vm_state
    end

    check_for_sound_cue
    update_timers
  end

  def needs_redraw?
    @vm[:draw_flag]
  end

  def draw
    @vm[:draw_flag] = false
    scale(RubyChip::SCALE, RubyChip::SCALE) do
      RubyChip::PIXELS.each do |x, y|
        next if @vm.graphics.at_xy(x, y).zero?
        draw_pixel(x, y, x + 1, y + 1, Gosu::Color::WHITE)
      end
    end
  end

  # initialize helpers

  def load(program)
    @vm       = RubyChip::VirtualMachine.new yaml('config/components.yml')
    @op_map   = RubyChip::OpcodeMap.new yaml('config/opcodes.yml'), @vm
    @key_map  = RubyChip::KeypadMap.new yaml('config/keys.yml')

    @vm.memory.load IO.binread(program).unpack('C*')
  end

  def yaml(file)
    YAML.load_file file
  end

  # update helpers

  def update_user_input
    close if button_down?(Gosu::KbEscape)
    @key_map.map.each { |id, i| @vm[:keypad][i] = button_down?(id) ? 1 : 0 }
  end

  def update_vm_state
    @op_map.lookup(@vm.opcode).execute.each { |comp, val| @vm[comp] = val }
  end

  def check_for_sound_cue
    @sound.play if @vm[:sound_timer] > 0
  end

  def update_timers
    [:delay_timer, :sound_timer].each { |t| @vm[t] = [@vm[t] - 1, 0].max }
  end

  # draw helpers

  def draw_pixel(x1, y1, x2, y2, color)
    draw_quad x1, y1, color, x1, y2, color, x2, y2, color, x2, y1, color
  end
end

window = Window.new
window.show
