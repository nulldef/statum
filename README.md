# Statum

![Build Status](https://travis-ci.org/nulldef/statum.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/nulldef/statum/badge.svg?branch=master)](https://coveralls.io/github/nulldef/statum?branch=master&v=1)

 Finite state machine for your objects 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statum

## Usage

### Basic usage
Statum provides a DSL for defining state machine for your class

```ruby
class Car
  include Statum
  
  attr_accessor :state
  
  statum :state, initial: :idle do
    state :idle
    state :riding
    
    event :ride, idle: :riding
  end
end
```

Then `Car` object will receive following methods:
```ruby
car = Car.new
car.idle? # => true
car.riding? # => false
car.ride! # changes idle state to riding
```

You can define an array of states which will be able to fire event:
```ruby
class Car
  include Statum
  
  attr_accessor :state
  
  statum :state, initial: :idle do
    state :idle
    state :parked
    state :riding
    
    event :ride, %i[idle parked] => :riding
  end
end
```

Also you can use `any_state` helper to say, that event can be fired from any of defined states
```ruby
class Car
  include Statum
  
  attr_accessor :state
  
  statum :state, initial: :idle do
    state :idle
    state :parked
    state :riding
    
    event :ride, any_state => :riding
  end
end
```

### Multiple state machines
You can define more than one state machine on your object.

**IMPORTANT** use unique fields to work with two or more states
```ruby
class Car
  include Statum

  attr_accessor :state, :engine

  statum :state do
    state :riding
    state :idle

    event :ride, idle: :riding
  end

  statum :engine do
    state :stopped
    state :started

    event :start, stopped: :started
  end
end
```

```ruby
car = Car.new
car.start! # changes engine to started
car.ride! # changes state to riding
``` 

### Hooks
You can be able to execute some procs before and after event will be fired

```ruby
class Car
  include Statum
  
  attr_accessor :state, :started
  
  statum :state, initial: :idle do
    state :idle
    state :riding
    
    event :ride, idle: :riding,
                 before: -> { self.started = true },
                 after: :stop_engine
  end
  
  def stop_engine
    self.started = false
  end
end
```

And then before state changes will be executed `before` proc, and after
changing - `after` proc (in instance context).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nulldef/statum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
