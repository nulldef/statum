# Statum

![Build Status](https://travis-ci.org/nulldef/statum.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/nulldef/statum/badge.svg?branch=master)](https://coveralls.io/github/nulldef/statum?branch=master?v=1)

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
