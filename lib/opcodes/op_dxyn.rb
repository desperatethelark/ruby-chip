# draw a sprite at (vx, vy)
class OpDXYN < RubyChip::Instruction
  def changes_from_execution
    sprite = flipped_pixels

    {
      draw_flag:  true,
      graphics:   sprite,
      register:   {
        f => bitmap(sprite.any? { |_, bit| bit.zero? })
      }
    }
  end

  private

  def flipped_pixels
    sprite_map.select { |_, bit| bit != 0 }.map do |address, _|
      [address, vm.graphics.at_address(address) ^ 1]
    end
  end

  def sprite_map
    (i...(n + i)).flat_map.with_index do |address, y_index|
      (0...8).map do |x_index|
        [vm.graphics.address_for(vx + x_index, vy + y_index),
         vm.memory.at(address) & (0x80 >> x_index)]
      end
    end
  end
end
