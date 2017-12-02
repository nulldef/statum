require "stateful/version"
require "stateful/state_definer"
require "stateful/machine"
require "stateful/event"

module Stateful
  UnknownEventError = Class.new(ArgumentError)
  ErrorTransitionError = Class.new(StandardError)

  class << self
    def included(base)
      base.extend(Stateful::ClassMethods)
      base.include(Stateful::InstanceMethods)
    end
  end

  module ClassMethods
    def stateful(field, options = {}, &block)
      definer = Stateful::StateDefiner.new(self, field, options)
      definer.instance_eval(&block) if block_given?
      instance_variable_set('@__stateful_machine', definer.state_machine)
    end

    def state_machine
      instance_variable_get('@__stateful_machine')
    end
  end

  module InstanceMethods
    def method_missing(meth, *args)
      if meth.to_s.end_with?('?') && state_machine.state?(meth[0...-1])
        state_machine.current(self) == meth[0...-1].to_sym
      elsif meth.to_s.end_with?('!') && state_machine.event?(meth[0...-1])
        state_machine.fire!(self, meth[0...-1])
      else
        super
      end
    end

    def respond_to_missing?(meth, *args)
      if meth.to_s.end_with?('?')
        state_machine.state?(meth[0...-1])
      elsif meth.to_s.end_with?('!')
        state_machine.event?(meth[0...-1])
      else
        super
      end
    end

    def state_machine
      self.class.state_machine
    end
  end
end
