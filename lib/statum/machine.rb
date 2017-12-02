module Statum
  # Class for representing event machine
  class Machine
    attr_reader :events, :states, :field

    # Creates machine instance
    #
    # @param [Hash] options options hash
    def initialize(options)
      @field   = options.delete(:field)
      @initial = options.delete(:initial)
      @states  = options.delete(:states)
      @events  = options.delete(:events)
    end

    # Checks if state present
    #
    # @param [String|Symbol] name state name
    #
    # @return [Boolean]
    def state?(name)
      @states.include?(name.to_sym)
    end

    # Checks if event present
    #
    # @param [String|Boolean] name event name
    #
    # @return [Boolean]
    def event?(name)
      @events.keys.include?(name.to_sym)
    end

    # Execute an event
    #
    # @param [Object] instance Instance of class, that includes Statum
    # @param [String|Symbol] name Event name
    def fire!(instance, name)
      raise Statum::UnknownEventError, "Event #{name} not found" unless event?(name)

      current_state = current(instance)
      event         = events[name.to_sym]

      unless event.can_fire?(current_state)
        raise Statum::ErrorTransitionError, "Cannot transition from #{current_state} to #{event.to}"
      end

      instance.instance_eval(&event.before) if event.before?
      instance.send("#{field}=", event.to)
      instance.instance_eval(&event.after) if event.after?
    end

    # Returns current state of instance
    #
    # @param [Object] instance Instance of class
    #
    # @return [Symbol] Current instance's state
    def current(instance)
      instance.send(field)&.to_sym || @initial
    end
  end
end
