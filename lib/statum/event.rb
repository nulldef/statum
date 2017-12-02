module Statum
  # Class for storing event info
  class Event
    attr_reader :from, :to, :before, :after

    # Creates an event class
    #
    # @param [String|Symbol] from From state name
    # @param [String|Symbol] to To state name
    # @param [Hash] options Options for event
    def initialize(from, to, options = {})
      @from   = from
      @to     = to
      @before = options.fetch(:before, nil)&.to_proc
      @after  = options.fetch(:after, nil)&.to_proc
    end

    # Returns true if event can be fired from current state
    #
    # @param [String|Symbol] current_state Current state
    #
    # @return [Boolean]
    def can_fire?(current_state)
      if from.is_a?(Array)
        from.include?(current_state.to_sym)
      elsif from == :__statum_any_state
        true
      else
        from == current_state.to_sym
      end
    end

    # Check if before hook exists
    # @return [boolean]
    def before?
      !before.nil?
    end

    # Checks if after hook present
    # @return [boolean]
    def after?
      !after.nil?
    end
  end
end
