require "statum/version"
require "statum/state_definer"
require "statum/machine"
require "statum/event"

module Statum
  UnknownEventError    = Class.new(ArgumentError)
  ErrorTransitionError = Class.new(StandardError)

  class << self
    def included(base)
      base.extend(Statum::ClassMethods)
      base.include(Statum::InstanceMethods)
    end
  end

  module ClassMethods
    def statum(field, options = {}, &block)
      definer = Statum::StateDefiner.new(self, field, options)
      definer.instance_eval(&block) if block_given?
      instance_variable_set('@__statum_machine', definer.state_machine)
    end

    def state_machine
      instance_variable_get('@__statum_machine')
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
