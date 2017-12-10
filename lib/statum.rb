require "statum/version"
require "statum/machine"
require "statum/hook"
require "statum/event"
require "statum/state_definer"

module Statum
  UnknownEventError    = Class.new(ArgumentError)
  ErrorTransitionError = Class.new(StandardError)
  ExistingMachineError = Class.new(ArgumentError)

  STATE_MACHINES_VARIABLE = '@__statum_machines'.freeze

  ANY_STATE_NAME = :__statum_any_state

  class << self
    def included(base)
      base.extend(Statum::ClassMethods)
      base.include(Statum::InstanceMethods)
    end
  end

  module ClassMethods
    def statum(field, options = {}, &block)
      definer = Statum::StateDefiner.new(self, field, options)
      definer.instance_eval(&block) if block_given?
      add_machine(definer.state_machine)
    end

    def state_machines
      instance_variable_get(STATE_MACHINES_VARIABLE) || []
    end

    private

    def add_machine(machine)
      if state_machines.any? { |m| m.name == machine.name }
        raise ExistingMachineError, "State machine for #{machine.name} already exists"
      end
      instance_variable_set(STATE_MACHINES_VARIABLE, state_machines + [machine])
    end
  end

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
