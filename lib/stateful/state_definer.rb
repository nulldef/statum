module Stateful
  class StateDefiner
    def initialize(klass, field, options)
      @klass   = klass
      @field   = field
      @initial = options.fetch(:initial, nil)
      @states  = []
      @events  = {}

      state(@initial) unless @initial.nil?
    end

    def state_machine
      Stateful::Machine.new(
        field: @field,
        initial: @initial,
        states: @states,
        events: @events
      )
    end

    def state(name)
      @states << name.to_sym unless @states.include?(name.to_sym)
    end

    def event(name, transition_hash)
      return if @events.key?(name.to_sym)

      @events[name.to_sym] = Stateful::Event.new(*transition_hash.flatten)
    end
  end
end
