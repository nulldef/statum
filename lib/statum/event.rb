module Statum
  # Class for storing event info
  #
  # @attr [Statum::Hook] before Before hook object
  # @attr [Statum::Hook] after After hook object
  # @attr [Symbol, Array] from From state name (or names)
  # @attr [Symbol] to To state name
  class Event
    attr_reader :from, :to, :before, :after

    # Creates an event class
    #
    # @param [Symbol, Array<Symbol>] from From state name
    # @param [Symbol] to To state name
    # @param [Hash] options Options for event
    def initialize(from, to, options = {})
      @from   = from.is_a?(Array) ? from.map(&:to_sym) : from.to_sym
      @to     = to.to_sym
      @before = Statum::Hook.new(options.fetch(:before, nil))
      @after = Statum::Hook.new(options.fetch(:after, nil))
    end

    # Returns true if event can be fired from current state
    #
    # @param [Symbol] current_state Current state
    #
    # @return [Boolean]
    def can_fire?(current_state)
      if from.is_a?(Array)
        from.include?(current_state.to_sym)
      elsif from == Statum::ANY_STATE_NAME
        true
      else
        from == current_state.to_sym
      end
    end
  end
end
