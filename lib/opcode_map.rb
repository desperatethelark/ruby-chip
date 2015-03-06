class RubyChip::OpcodeMap
  def initialize opcodes
    @map = opcodes.map { |code| [regex(code), obj(code)] }
  end
  
  def lookup opcode
    @map.each { |regex,op| return op if regex =~ opcode }

    nil
  end

  private

  def regex code
    /#{code.gsub(/[XYN]/, "(.)")}/
  end

  def obj code
    Object.const_get("Op#{code}").new
  end
end