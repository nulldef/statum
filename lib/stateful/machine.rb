module Stateful
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
    # @param [Object] instance Instance of class, that includes Stateful
    # @param [String|Symbol] name Event name
    def fire!(instance, name)
      raise Stateful::UnknownEventError, "Event #{name} not found" unless event?(name)

      current_state = instance.send(field)&.to_sym || @initial
      event         = events[name.to_sym]

      if event.from != current_state
        raise Stateful::ErrorTransitionError, "Cannot transition from #{current_state} to #{event.to}"
      end

      instance.instance_eval(&event.before) if event.before?
      instance.send("#{field}=", event.to)
      instance.instance_eval(&event.after) if event.after?
    end
  end
end
