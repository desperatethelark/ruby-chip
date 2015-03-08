module RubyChip
  # container class for all of the components
  class VirtualMachine
    def initialize(components)
      components.each do |comp|
        instance_variable_set :"@#{comp}",
                              Object.const_get(klass comp).from_default

        VirtualMachine.class_eval { attr_accessor comp.to_sym }
      end
    end

    def current_instruction
      memory.bytes_from self[:program_counter]
    end

    def opcode
      format '%04X', current_instruction
    end

    def [](component)
      send(component).state
    end

    def []=(component, new_state)
      send(component).state = new_state
    end

    private

    def klass(component)
      component
        .split('_')
        .map(&:capitalize)
        .join
    end
  end
end
