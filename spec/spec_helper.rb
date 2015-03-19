require 'yaml'

require_relative '../ruby_chip.rb'
Dir['lib/*.rb'].each { |rb| require_relative "../#{rb}" }
Dir['lib/*/*.rb'].each { |rb| require_relative "../#{rb}" }

RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec do |mock|
    mock.syntax = [:expect, :should]
    # mock.syntax = :should
    # mock.syntax = :expect
  end
end
