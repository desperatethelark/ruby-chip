# RubyChip: a Chip-8 interpreter/emulator in Ruby
module RubyChip
  WIDTH   = 64
  HEIGHT  = 32
  SCALE   = 10
  PIXELS  = Array(0..WIDTH).product Array(0..HEIGHT)
end

require 'gosu'
require 'yaml'

Dir['lib/*.rb'].each { |rb| require_relative rb }
Dir['lib/*/*.rb'].each { |rb| require_relative rb }
