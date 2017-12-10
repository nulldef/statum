module Statum
  # Hook wrapper for Statum::Event
  class Hook
    # Creates new Hook instance
    #
    # @param [Symbol, Proc] hook Callable object or symbol that represents instance method
    def initialize(hook)
      @hook = hook
    end

    # Execute hook on instane
    #
    # @param [Object] instance Class instance
    def evaluate(instance)
      return if @hook.nil?
      hook = find_hook(instance)
      if hook.arity.zero?
        instance.instance_exec(&hook)
      else
        instance.instance_exec(instance, &hook)
      end
    end

    private

    # Finds hook on instance
    #
    # @param [Object] instance Instance of class that included Statum
    #
    # @return [Proc]
    def find_hook(instance)
      @hook.respond_to?(:call) ? @hook : instance.method(@hook)
    end
  end
end
