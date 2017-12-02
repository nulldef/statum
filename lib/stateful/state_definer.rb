module Stateful
  # Class for create hash options for machine
  class StateDefiner
    # Creates an instance of definer
    #
    # @param [Class] klass Class that includes Stateful
    # @param [String|Symbol] field Field that will be used for storing current state
    # @param [Hash] options Hash options
    def initialize(klass, field, options)
      @klass   = klass
      @field   = field.to_sym
      @initial = options.fetch(:initial, nil)
      @states  = []
      @events  = {}

      state(@initial) unless @initial.nil?
    end

    # Returns state maching
    #
    # @return [Stateful::Machine]
    def state_machine
      Stateful::Machine.new(
        field:   @field,
        initial: @initial,
        states:  @states,
        events:  @events
      )
    end

    # Define a new state
    #
    # @param [String|Symbol] name State name
    def state(name)
      @states << name.to_sym unless @states.include?(name.to_sym)
    end

    # Define a new event
    #
    # @param [String|Symbol] name Event name
    # @param [Hash] options Options hash
    # First key-value pair must be 'from' and 'to' transition states
    # Other pairs are event options
    def event(name, options)
      return if @events.key?(name.to_sym)

      from, to = options.shift
      @events[name.to_sym] = Stateful::Event.new(from, to, options)
    end
  end
end
