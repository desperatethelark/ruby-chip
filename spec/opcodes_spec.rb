require 'spec_helper'

describe 'Opcodes' do
  before :all do
    @components = YAML.load_file('config/components.yml')
  end

  before :each do
    @vm = RubyChip::VirtualMachine.new @components
  end

  describe 'Op00E0' do
    let(:op) { Op00E0.new(@vm).changes_from_execution }

    it 'triggers a redraw' do
      expect(op[:draw_flag]).to eq(true)
    end

    it 'clears the graphics' do
      expect(op[:graphics]).to eq(Graphics.default_state)
    end
  end

  describe 'Op00EE' do
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

  describe 'Op1NNN' do
    let(:op) { Op1NNN.new(@vm).changes_from_execution }

    it 'sets the program counter to the address NNN' do
      @vm.stub(:current_instruction) { 0x1999 }
      expect(op[:program_counter]).to eq(0x999)
    end
  end

  describe 'Op2NNN' do
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

  describe 'Op3XNN' do
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

  describe 'Op4XNN' do
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

  describe 'Op5XY0' do
    let(:op) { Op5XY0.new(@vm).changes_from_execution }

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

    context 'when vx == nn' do
      it 'increments the program counter normally' do
        @vm[:register] = { 1 => 0xF, 2 => 0xCC }
        expect(op[:program_counter]).to eq(2)
      end
    end
  end

  describe 'Op6XNN' do
    let(:op) { Op6XNN.new(@vm).changes_from_execution }

    before :each do
      @vm.stub(:current_instruction) { 0x6425 }
    end

    it 'sets vx to nn' do
      expect(op[:register][4]).to eq(0x25)
    end
  end

  describe 'Op7XNN' do
    let(:op) { Op7XNN.new(@vm).changes_from_execution }

    before :each do
      @vm[:register] = { 1 => 0x19 }
      @vm.stub(:current_instruction) { 0x7166 }
    end

    it 'sets vx to vx + nn' do
      expect(op[:register][1]).to eq(0x19 + 0x66)
    end
  end
end
