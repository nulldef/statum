class Car
  include Statum

  attr_accessor :state

  statum :state, initial: :parked do
    state :parked
    state :riding

    event :ride, parked: :riding
    event :stop, riding: :parked
  end
end

class ArrayCar
  include Statum

  attr_accessor :state

  statum :state, initial: :parked do
    state :parked
    state :idle
    state :riding

    event :ride, %i[parked idle] => :riding
  end
end

class AnyStateCar
  include Statum

  attr_accessor :state

  def initialize(initial)
    self.state = initial
  end

  statum :state, initial: :crashed do
    state :parked
    state :idle
    state :crashed
    state :riding

    event :ride, any_state => :riding
  end
end

RSpec.describe Statum do
  let(:car) { Car.new }

  it "has boolean helper methods" do
    expect(car.parked?).to be_truthy
    expect(car.riding?).to be_falsey
  end

  it "has state methods" do
    expect(car).to respond_to(:parked?)
    expect(car).to respond_to(:riding?)
  end

  it "raises error when state is unknown" do
    expect { car.unknown? }.to raise_error(NoMethodError)
    expect(car).not_to respond_to(:unknown?)
  end

  it "has event methods" do
    expect(car).to respond_to(:ride!)
    expect(car).to respond_to(:stop!)
  end

  it "fires events and changes state" do
    car.ride!
    expect(car.riding?).to be_truthy
  end

  it "fires event from any of states in array" do
    parked_car       = ArrayCar.new
    parked_car.state = :parked
    expect { parked_car.ride! }.to change { parked_car.state }
    expect(parked_car.state).to eq(:riding)

    idle_car       = ArrayCar.new
    idle_car.state = :idle
    expect { idle_car.ride! }.to change { idle_car.state }
    expect(idle_car.state).to eq(:riding)
  end

  it "fires event from any of states" do
    [
      AnyStateCar.new(:parked),
      AnyStateCar.new(:crashed),
      AnyStateCar.new(:idle)
    ].each do |car|
      expect { car.ride! }.to change { car.state }
      expect(car.state).to eq(:riding)
    end
  end

  it "raises error when event not exists" do
    expect { car.unknown! }.to raise_error(NoMethodError)
    expect(car).not_to respond_to(:unknown!)
    expect(car).not_to respond_to(:unknown_method)
  end

  it "raises error when 'from state' is not valid" do
    car.state = :riding
    expect { car.ride! }.to raise_error(Statum::ErrorTransitionError)
  end
end
