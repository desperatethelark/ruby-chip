require 'spec_helper'

describe 'Opcode' do
  let(:op) { described_class.new(@vm).changes_from_execution }

  before :all do
    @components = YAML.load_file('config/components.yml')
  end

  before :each do
    @vm = RubyChip::VirtualMachine.new @components
  end

  describe Op00E0 do
    let(:op) { Op00E0.new(@vm).changes_from_execution }

    it 'triggers a redraw' do
      expect(op[:draw_flag]).to eq(true)
    end

    it 'clears the graphics' do
      expect(op[:graphics]).to eq(Graphics.default_state)
    end
  end

  describe Op00EE do
    let(:op) { Op00EE.new(@vm).changes_from_execution }

    before :each do
      @vm[:stack] = [50, 100]
      @vm[:program_counter] = 42
    end

    it 'removes the last element of the stack' do
      expect(op[:stack]).to contain_exactly(50)
    end

    it 'sets the program counter to the last stack element and increments' do
      expect(op[:program_counter]).to eq(102)
    end
  end

  describe Op1NNN do
    let(:op) { Op1NNN.new(@vm).changes_from_execution }

    it 'sets the program counter to the address NNN' do
      @vm.stub(:current_instruction) { 0x1999 }
      expect(op[:program_counter]).to eq(0x999)
    end
  end

  describe Op2NNN do
    let(:op) { Op2NNN.new(@vm).changes_from_execution }

    before :each do
      @vm[:stack] = [17]
      @vm[:program_counter] = 42
      @vm.stub(:current_instruction) { 0x2999 }
    end

    it 'sets the program counter to the address NNN' do
      expect(op[:program_counter]).to eq(0x999)
    end

    it 'stores the current program counter in the stack' do
      expect(op[:stack]).to contain_exactly(17, 42)
    end
  end

  describe Op3XNN do
    let(:op) { Op3XNN.new(@vm).changes_from_execution }

    before :each do
      @vm[:program_counter] = 0
      @vm.stub(:current_instruction) { 0x3255 }
    end

    context 'when vx == nn' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:register] = { 2 => 0x55 }
        expect(op[:program_counter]).to eq(4)
      end
    end

    context 'when vx != nn' do
      it 'increments the program counter normally' do
        @vm[:register] = { 2 => 0x22 }
        expect(op[:program_counter]).to eq(2)
      end
    end
  end

  describe Op4XNN do
    let(:op) { Op4XNN.new(@vm).changes_from_execution }

    before :each do
      @vm[:program_counter] = 0
      @vm.stub(:current_instruction) { 0x4255 }
    end

    context 'when vx != nn' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:register] = { 2 => 0x22 }
        expect(op[:program_counter]).to eq(4)
      end
    end

    context 'when vx == nn' do
      it 'increments the program counter normally' do
        @vm[:register] = { 2 => 0x55 }
        expect(op[:program_counter]).to eq(2)
      end
    end
  end

  describe Op5XY0 do
    before :each do
      @vm[:program_counter] = 0
      @vm.stub(:current_instruction) { 0x5120 }
    end

    context 'when vx == vy' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:register] = { 1 => 0xF, 2 => 0xF }
        expect(op[:program_counter]).to eq(4)
      end
    end

    context 'when vx =! vy' do
      it 'increments the program counter normally' do
        @vm[:register] = { 1 => 0xF, 2 => 0xCC }
        expect(op[:program_counter]).to eq(2)
      end
    end
  end

  describe Op6XNN do
    before :each do
      @vm.stub(:current_instruction) { 0x6425 }
    end

    it 'sets vx to nn' do
      expect(op[:register][4]).to eq(0x25)
    end
  end

  describe Op7XNN do
    before :each do
      @vm[:register] = { 1 => 0x19 }
      @vm.stub(:current_instruction) { 0x7166 }
    end

    it 'sets vx to vx + nn' do
      expect(op[:register][1]).to eq(0x19 + 0x66)
    end
  end

  describe Op8XY0 do
    before :each do
      @vm.stub(:current_instruction) { 0x8010 }
      @vm[:register] = { 1 => 0xDD }
    end

    it 'sets vx to vy' do
      expect(op[:register][0]).to eq(0xDD)
    end
  end

  describe Op8XY1 do
    before :each do
      @vm.stub(:current_instruction) { 0x8011 }
      @vm[:register] = { 0 => 0x01, 1 => 0x11 }
    end

    it 'sets vx to vx OR vy' do
      expect(op[:register][0]).to eq(0x11)
    end
  end

  describe Op8XY2 do
    before :each do
      @vm.stub(:current_instruction) { 0x8012 }
      @vm[:register] = { 0 => 0x01, 1 => 0x11 }
    end

    it 'sets vx to vx AND vy' do
      expect(op[:register][0]).to eq(0x01)
    end
  end

  describe Op8XY3 do
    before :each do
      @vm.stub(:current_instruction) { 0x8013 }
      @vm[:register] = { 0 => 0x01, 1 => 0x11 }
    end

    it 'sets vx to vx XOR vy' do
      expect(op[:register][0]).to eq(0x10)
    end
  end

  describe Op8XY4 do
    before :each do
      @vm.stub(:current_instruction) { 0x8014 }
    end

    it 'sets vx to vx + vy' do
      @vm[:register] = { 0 => 0xFF, 1 => 0x01 }
      expect(op[:register][0]).to eq(0x100)
    end

    context 'when vx + vy exceeds 0xFF' do
      it 'sets vf to 1' do
        @vm[:register] = { 0 => 0xFF, 1 => 0x01 }
        expect(op[:register][15]).to eq(1)
      end
    end

    context 'when vx + vy does not exceed 0xFF' do
      it 'sets vf to 0' do
        @vm[:register] = { 0 => 0xFF, 1 => 0x00 }
        expect(op[:register][15]).to eq(0)
      end
    end
  end

  describe Op8XY5 do
    before :each do
      @vm.stub(:current_instruction) { 0x8015 }
    end

    it 'sets vx to vx - vy' do
      @vm[:register] = { 0 => 0xFF, 1 => 0x0F }
      expect(op[:register][0]).to eq(0xF0)
    end

    context 'when vx - vy is negative' do
      it 'sets vf to 0' do
        @vm[:register] = { 0 => 0x01, 1 => 0xFF }
        expect(op[:register][15]).to eq(0)
      end
    end

    context 'when vx - vy is nonnegative' do
      it 'sets vf to 1' do
        @vm[:register] = { 0 => 0xFF, 1 => 0x00 }
        expect(op[:register][15]).to eq(1)
      end
    end
  end

  describe Op8XY6 do
    before :each do
      @vm.stub(:current_instruction) { 0x8016 }
      @vm[:register] = { 0 => 0x04 }
    end

    it 'left shifts vx by 1' do
      expect(op[:register][0]).to eq(0x02)
    end

    it 'stores the least significant bit in of vx vf' do
      expect(op[:register][15]).to eq(0x0)
    end
  end

  describe Op8XY7 do
    before :each do
      @vm.stub(:current_instruction) { 0x8017 }
    end

    it 'sets vx to vy - vx' do
      @vm[:register] = { 0 => 0x0F, 1 => 0xFF }
      expect(op[:register][0]).to eq(0xF0)
    end

    context 'when vy < vx ' do
      it 'sets vf to 0' do
        @vm[:register] = { 0 => 0x01, 1 => 0x00 }
        expect(op[:register][15]).to eq(0)
      end
    end

    context 'when vy > vx' do
      it 'sets vf to 1' do
        @vm[:register] = { 0 => 0x01, 1 => 0x02 }
        expect(op[:register][15]).to eq(1)
      end
    end
  end

  describe Op8XYE do
    before :each do
      @vm.stub(:current_instruction) { 0x801E }
      @vm[:register] = { 0 => 0x04 }
    end

    it 'right shifts vx by 1' do
      expect(op[:register][0]).to eq(0x08)
    end

    it 'stores the most significant bit in of vx vf' do
      expect(op[:register][15]).to eq(0x0)
    end
  end

  describe Op9XY0 do
    before :each do
      @vm[:program_counter] = 0
      @vm.stub(:current_instruction) { 0x9010 }
    end

    context 'when vx != vy' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:register] = { 0 => 0xF, 1 => 0x0 }
        expect(op[:program_counter]).to eq(4)
      end
    end

    context 'when vx == vy' do
      it 'increments the program counter normally' do
        @vm[:register] = { 0 => 0xF, 1 => 0xF }
        expect(op[:program_counter]).to eq(2)
      end
    end
  end

  describe OpANNN do
    before :each do
      @vm[:index] = 0
      @vm.stub(:current_instruction) { 0xAFFF }
    end

    it 'sets the index to NNN' do
      expect(op[:index]).to eq(0xFFF)
    end
  end

  describe OpBNNN do
    before :each do
      @vm[:program_counter] = 0
      @vm[:register] = { 0 => 0x01 }
      @vm.stub(:current_instruction) { 0xA001 }
    end

    it 'sets the program counter to NNN + V0' do
      expect(op[:program_counter]).to eq(0x02)
    end
  end

  describe OpCXNN do
    before :each do
      @vm.stub(:current_instruction) { 0xC022 }
    end

    it 'sets VX to a random number between 0x0 and 0xFF' do
      expect(op[:register][0]).to be_between(0x0, 0xFF)
    end

    it 'masks the random number by NN' do
      random_number = op[:register][0]
      expect(random_number).to eq(random_number & 0x22)
    end
  end

  describe OpDXYN do
    before :each do
      @vm.stub(:current_instruction) { 0xD252 }
    end

    it 'triggers a redraw' do
      expect(op[:draw_flag]).to eq(true)
    end
  end

  describe OpEX9E do
    before :each do
      @vm[:register] = { 0 => 0x5 }
      @vm.stub(:current_instruction) { 0xE09E }
    end

    context 'when the key at VX is pressed' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:keypad] = { 5 => 1 }
        expect(op[:program_counter]).to eq(@vm[:program_counter] + 4)
      end
    end

    context 'when the key at VX is pressed' do
      it 'increments the program counter normally' do
        @vm[:keypad] = { 5 => 0 }
        expect(op[:program_counter]).to eq(@vm[:program_counter] + 2)
      end
    end
  end

  describe OpEXA1 do
    before :each do
      @vm[:register] = { 0 => 0x5 }
      @vm.stub(:current_instruction) { 0xE0A1 }
    end

    context 'when the key at VX is pressed' do
      it 'increments the program counter by twice the normal amount' do
        @vm[:keypad] = { 5 => 0 }
        expect(op[:program_counter]).to eq(@vm[:program_counter] + 4)
      end
    end

    context 'when the key at VX is pressed' do
      it 'increments the program counter normally' do
        @vm[:keypad] = { 5 => 1 }
        expect(op[:program_counter]).to eq(@vm[:program_counter] + 2)
      end
    end
  end

  describe OpFX07 do
    before :each do
      @vm[:delay_timer] = 12
      @vm.stub(:current_instruction) { 0xF007 }
    end

    it 'sets VX to the delay timer' do
      expect(op[:register][0]).to eq(12)
    end
  end

  describe OpFX0A do
    before :each do
      @vm[:register] = { 0 => 0x12 }
      @vm.stub(:current_instruction) { 0xF015 }
    end

    context 'when there is a key being pressed' do
      it 'stores the keypress in VX' do
        @vm[:keypad] = [0, 0, 1, 0]
        expect(op[:register][0]).to eq(@vm[:keypad].index(1))
      end
    end

    context 'when there is no key being pressed' do
      it 'sets the program_counter to itself' do
        @vm[:keypad] = [0, 0, 0, 0]
        expect(op[:program_counter]).to eq(@vm[:program_counter])
      end
    end
  end

  describe OpFX15 do
    before :each do
      @vm[:register] = { 0 => 0x12 }
      @vm.stub(:current_instruction) { 0xF015 }
    end

    it 'sets the delay timer to VX' do
      expect(op[:delay_timer]).to eq(@vm[:register][0])
    end
  end

  describe OpFX18 do
    before :each do
      @vm[:register] = { 0 => 0x12 }
      @vm.stub(:current_instruction) { 0xF018 }
    end

    it 'sets the sound timer to VX' do
      expect(op[:sound_timer]).to eq(@vm[:register][0])
    end
  end

  describe OpFX1E do
    before :each do
      @vm[:index] = 0xFF0
      @vm.stub(:current_instruction) { 0xF01E }
    end

    it 'sets I to I + VX ' do
      expect(op[:index]).to eq(@vm[:index] + @vm[:register][0])
    end

    context 'when I + VX exceeds 0xFFF' do
      it 'sets VF to 1' do
        @vm[:register] = { 0 => 0xFF }
        expect(op[:register][15]).to eq(1)
      end
    end

    context 'when I + VX does not exceed 0xFFF' do
      it 'sets VF to 0' do
        @vm[:register] = { 0 => 0x0F }
        expect(op[:register][15]).to eq(0)
      end
    end
  end

  describe OpFX29 do
    before :each do
      @vm[:register] = { 0 => 0xFF }
      @vm.stub(:current_instruction) { 0xF029 }
    end

    it 'sets I to VX * 0x5' do
      expect(op[:index]).to eq(@vm[:register][0] * 0x5)
    end
  end
end
