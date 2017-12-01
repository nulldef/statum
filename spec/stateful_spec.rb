class Car
  include Stateful

  attr_accessor :state

  stateful :state, initial: :parked do
    state :parked
    state :riding

    event :ride, parked: :riding
    event :stop, riding: :parked
  end
end

RSpec.describe Stateful do
  let(:car) { Car.new }

  it "has boolean helper methods" do
    car.state = :parked
    expect(car.parked?).to be_truthy
    expect(car.riding?).to be_falsey
  end

  it "has event methods" do
    expect(car).to respond_to(:ride!)
    expect(car).to respond_to(:stop!)
  end

  it "fires events and changes state" do
    car.ride!
    expect(car.riding?).to be_truthy
  end
end
