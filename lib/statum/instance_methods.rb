module Statum
  module InstanceMethods
    def method_missing(meth, *args)
      if meth.to_s.end_with?('?') && (machine = find_machine_by_state(meth[0...-1]))
        machine.current(self) == meth[0...-1].to_sym
      elsif meth.to_s.end_with?('!') && (machine = find_machine_by_event(meth[0...-1]))
        machine.fire!(self, meth[0...-1])
      else
        super
      end
    end

    def respond_to_missing?(meth, *args)
      if meth.to_s.end_with?('?')
        !find_machine_by_state(meth[0...-1]).nil?
      elsif meth.to_s.end_with?('!')
        !find_machine_by_event(meth[0...-1]).nil?
      else
        super
      end
    end

    private

    def find_machine_by_event(name)
      state_machines.select { |machine| machine.event?(name) }.first
    end

    def find_machine_by_state(name)
      state_machines.select { |machine| machine.state?(name) }.first
    end

    def state_machines
      self.class.state_machines
    end
  end
end
