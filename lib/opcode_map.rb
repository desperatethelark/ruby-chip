class RubyChip::OpcodeMap
  def initialize opcodes, vm
    @map = opcodes.map { |code| [regex(code), obj(code, vm)] }
  end
  
  def lookup opcode
    @map.each { |regex,op| return op if regex =~ opcode }

    nil
  end

  private

  def regex code
    /#{code.gsub(/[XYN]/, "(.)")}/
  end

  def obj code, vm
    Object.const_get("Op#{code}").new vm
  end
end