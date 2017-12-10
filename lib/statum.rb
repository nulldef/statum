require "statum/version"
require "statum/class_methods"
require "statum/instance_methods"
require "statum/machine"
require "statum/hook"
require "statum/event"
require "statum/state_definer"

module Statum
  # Error for unknown event
  UnknownEventError    = Class.new(ArgumentError)

  # Error for wrong transition
  ErrorTransitionError = Class.new(StandardError)

  # Error for duplicated state machine
  ExistingMachineError = Class.new(ArgumentError)

  # Variable to store state machines
  STATE_MACHINES_VARIABLE = '@__statum_machines'.freeze

  # Any state identifier
  ANY_STATE_NAME = :__statum_any_state

  class << self
    def included(base)
      base.extend(Statum::ClassMethods)
      base.include(Statum::InstanceMethods)
    end
  end
end
