class RubyChip::VirtualMachine
  def initialize components
    components.each do |name, klass|
      instance_variable_set :"@#{name}", Object.const_get(klass).from_default
      RubyChip::VirtualMachine.class_eval { attr_accessor name.to_sym }
    end
  end

  def current_instruction
    memory.bytes_from self[:program_counter]
  end

  def opcode
    "%04X" % current_instruction
  end

  def [] component
    send(component).state
  end

  def []= component, new_state
    send(component).state = new_state
  end
end