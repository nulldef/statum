module Statum
  # Class for representing event machine
  #
  # @attr_reader [Hash] events Events
  # @attr_reader [Array<Symbol>] states States
  # @attr_reader [Symbol] field State field
  class Machine
    attr_reader :events, :states, :field

    # Use state field for name of machine
    alias name field

    # Creates machine instance
    #
    # @param [Hash] options options hash
    # @option options [Symbol] field Field to store state
    # @option options [Symbol] initial Initial state
    # @option options [Array<Symbol>] states States
    # @option options [Hash] events Events
    def initialize(options)
      @field   = options.delete(:field)
      @initial = options.delete(:initial)
      @states  = options.delete(:states)
      @events  = options.delete(:events)
    end

    # Checks if state present
    #
    # @param [Symbol] name state name
    #
    # @return [Boolean]
    def state?(name)
      @states.include?(name.to_sym)
    end

    # Checks if event present
    #
    # @param [Symbol] name event name
    #
    # @return [Boolean]
    def event?(name)
      @events.keys.include?(name.to_sym)
    end

    # Execute an event
    #
    # @param [Object] instance Instance of class, that includes Statum
    # @param [Symbol] name Event name
    #
    # @raise Statum::UnknownEventError
    # @raise Statum::ErrorTransitionError
    def fire!(instance, name)
      raise Statum::UnknownEventError, "Event #{name} not found" unless event?(name)

      current_state = current(instance)
      event         = events[name.to_sym]

      unless event.can_fire?(current_state)
        raise Statum::ErrorTransitionError, "Cannot transition from #{current_state} to #{event.to}"
      end

      event.before.evaluate(instance)
      instance.send("#{field}=", event.to)
      event.after.evaluate(instance)
    end

    # Returns current state of instance
    #
    # @param [Object] instance Instance of class
    #
    # @return [Symbol] Current instance's state
    def current(instance)
      value = instance.send(field)
      value.nil? ? @initial : value.to_sym
    end
  end
end
