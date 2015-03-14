require_relative './ruby_chip'

# Gosu window for running the game loop and rendering
class Window < Gosu::Window
  WIDTH  = RubyChip::WIDTH  * RubyChip::SCALE
  HEIGHT = RubyChip::HEIGHT * RubyChip::SCALE
  FULLSCREEN = false
  SPEED = 10

  def initialize
    super(WIDTH, HEIGHT, FULLSCREEN)
    self.caption = "RubyChip - #{ARGV[0]}"
    @sound = Gosu::Song.new(self, 'sound.wav')
    load("programs/#{ARGV[0]}")
  end

  def update
    8.times { update_user_input; update_vm_state }
    check_for_sound_cue
    update_timers
  end

  def needs_redraw?
    @vm[:draw_flag]
  end

  def draw
    scale(RubyChip::SCALE, RubyChip::SCALE) do
      RubyChip::PIXELS.each do |x, y|
        next if @vm.graphics.at_xy(x, y).zero?

        draw_quad (x),      (y),      Gosu::Color::WHITE,
                  (x),      (y + 1),  Gosu::Color::WHITE,
                  (x + 1),  (y + 1),  Gosu::Color::WHITE,
                  (x + 1),  (y),      Gosu::Color::WHITE
      end
    end
    @vm[:draw_flag] = false
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
end

window = Window.new
window.show
