module RubyChip
  # superclass of everything in lib/opcodes
  class Instruction
    attr_accessor :vm

    def initialize(vm)
      @vm = vm
    end

    def execute
      default_instruction.merge(changes_from_execution)
    end

    private

    def default_instruction
      { program_counter: @vm[:program_counter] + 2 }
    end

    def update_vx(value)
      update(register: { x => value })
    end

    def conditional_instruction_skip(condition)
      @vm[:program_counter] + (condition ? 4 : 2)
    end

    def bitmap(boolean)
      boolean ? 1 : 0
    end

    define_method(:nnn) { @vm.current_instruction & 0x0FFF }
    define_method(:nn)  { @vm.current_instruction & 0x00FF }
    define_method(:n)   { @vm.current_instruction & 0x000F }

    define_method(:x) { (@vm.current_instruction & 0x0F00) >> 8 }
    define_method(:y) { (@vm.current_instruction & 0x00F0) >> 4 }
    define_method(:f) { 15 }

    define_method(:vx) { @vm[:register][x] }
    define_method(:vy) { @vm[:register][y] }
    define_method(:v0) { @vm[:register][0] }

    define_method(:i) { @vm[:index] }
  end
end
