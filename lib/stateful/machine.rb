module Stateful
  class Machine
    attr_reader :events, :states, :field

    def initialize(options)
      @field   = options.delete(:field)
      @initial = options.delete(:initial)
      @states  = options.delete(:states)
      @events  = options.delete(:events)
    end

    def state?(name)
      @states.include?(name.to_sym)
    end

    def event?(name)
      @events.keys.include?(name.to_sym)
    end

    def fire!(instance, name)
      raise Stateful::UnknownEventError, "Event #{name} not found" unless event?(name)

      current_state = instance.send(field)&.to_sym || @initial
      event         = events[name.to_sym]

      if event.from != current_state
        raise Stateful::ErrorTransitionError, "Cannot transition from #{current_state} to #{event.to}"
      end

      instance.send("#{field}=", event.to)
    end
  end
end
