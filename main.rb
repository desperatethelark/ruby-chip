require 'gosu'
require 'yaml'

require_relative './ruby_chip.rb'
require_relative './window.rb'

Dir['lib/*.rb'].each { |rb| require_relative rb }
Dir['lib/*/*.rb'].each { |rb| require_relative rb }

window = Window.new
window.show
