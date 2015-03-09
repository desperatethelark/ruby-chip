# RubyChip: a Chip-8 interpreter/emulator in Ruby
module RubyChip
  WIDTH   = 64
  HEIGHT  = 32
  SCALE   = 10
end

require 'gosu'
require 'yaml'

Dir['lib/*.rb'].each { |rb| require_relative rb }
Dir['lib/*/*.rb'].each { |rb| require_relative rb }
