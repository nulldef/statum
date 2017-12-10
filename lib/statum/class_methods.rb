module Statum
  module ClassMethods
    # Define new state machine
    #
    # @param [Symbol] field Field to store state
    # @param [Hash] options Options
    # @option options [Symbol] initial Initial value
    # @param [Block] block Bloc with DSL
    def statum(field, options = {}, &block)
      definer = Statum::StateDefiner.new(self, field, options)
      definer.instance_eval(&block) if block_given?
      add_machine(definer.state_machine)
    end

    # Returns defined state machines
    #
    # @return [Array<Statum::Machine>]
    def state_machines
      instance_variable_get(STATE_MACHINES_VARIABLE) || []
    end

    private

    # Add new state machine
    #
    # @param [Statum::Machine] machine New state machine
    # @raise Statum::ExistingMachineError
    def add_machine(machine)
      if state_machines.any? { |m| m.name == machine.name }
        raise Statum::ExistingMachineError, "State machine for #{machine.name} already exists"
      end
      instance_variable_set(STATE_MACHINES_VARIABLE, state_machines + [machine])
    end
  end
end
