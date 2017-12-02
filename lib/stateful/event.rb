module Stateful
  # Class for storing event info
  class Event
    attr_reader :from, :to, :before, :after

    # Creates an event class
    #
    # @param [String|Symbol] from From state name
    # @param [String|Symbol] to To state name
    # @param [Hash] options Options for event
    def initialize(from, to, options = {})
      @from = from
      @to = to
      @before = options.fetch(:before, nil)
      @after = options.fetch(:after, nil)
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
