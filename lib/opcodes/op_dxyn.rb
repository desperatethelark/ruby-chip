# draw a sprite at (vx, vy)
class OpDXYN < RubyChip::Instruction
  def changes_from_execution
    {
      draw_flag:  true,
      graphics:   sprite,
      register:   {
        f => bitmap(sprite.any? { |_, bit| bit.zero? })
      }
    }
  end

  private

  def sprite
    sprite_map.select { |_, bit| bit != 0 }.map do |address, _|
      [address, vm.graphics.at_address(address) ^ 1]
    end
  end

  def sprite_map
    (i...(n + i)).flat_map.with_index do |address, y_index|
      (0...8).map { |x_index| pixel_map(x_index, y_index, address) }
    end
  end

  def pixel_map(x, y, pixel)
    [vm.graphics.address_for(vx + x, vy + y), vm[:memory][pixel] & (0x80 >> x)]
  end
end
