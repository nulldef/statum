class BeforeCar
  include Stateful

  attr_accessor :state, :started

  stateful :state, initial: :idle do
    state :idle
    state :driving

    event :drive, idle: :driving, before: -> { self.started = true }
  end
end

class AfterCar
  include Stateful

  attr_accessor :state, :started

  stateful :state, initial: :driving do
    state :idle
    state :driving

    event :stop, driving: :idle, after: -> { self.started = false }
  end
end

class DelegatedCar
  include Stateful

  attr_accessor :state, :started

  stateful :state, initial: :idle do
    state :idle
    state :driving

    event :start, idle: :driving, before: :start_engine
  end

  def start_engine
    self.started = true
  end
end

RSpec.describe "Stateful Hooks" do
  it "runs hooks before event in instance context" do
    car = BeforeCar.new
    expect(car.started).not_to be_truthy
    car.drive!
    expect(car.started).to be_truthy
    expect(car.state).to eq(:driving)
  end

  it "runs hooks after event in instance context" do
    car = AfterCar.new
    car.started = true
    car.stop!
    expect(car.started).to be_falsey
    expect(car.state).to eq(:idle)
  end

  it "runs method hook" do
    car = DelegatedCar.new
    car.start!
    expect(car.started).to be_truthy
    expect(car.state).to eq(:driving)
  end
end
