class OpDXYN < RubyChip::Instruction
  def draw_8_by_n_sprite
    sprite = flipped_pixels
    update draw_flag: true, graphics: sprite, register: registers(sprite)
  end

  alias_method :execute, :draw_8_by_n_sprite

  private

  def sprite_map
    (i...(n + i)).flat_map.with_index do |address, y_index|
      (0...8).map do |x_index| 
        [ vm.graphics.address_for(vx + x_index, vy + y_index),
          vm.memory.at(address) & (0x80 >> x_index) ]
      end
    end
  end

  def flipped_pixels
    sprite_map.select { |address, bit| bit != 0 }.map do |address, bit|
      [address, vm.graphics.at_address(address) ^ 1]
    end
  end

  def registers sprite
    { f => bitmap(sprite.any? { |addr,bit| bit.zero? }) }
  end
end