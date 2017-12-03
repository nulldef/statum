class MultiCar
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

class ExistsCar
  include Statum

  attr_accessor :state, :engine

  statum :state do
    state :riding
    state :idle
  end
end

RSpec.describe "Statum multimachine" do
  let(:car) { MultiCar.new }

  it "have all helper methods" do
    expect(car).to respond_to(:riding?)
    expect(car).to respond_to(:idle?)
    expect(car).to respond_to(:started?)
    expect(car).to respond_to(:stopped?)

    expect(car).to respond_to(:ride!)
    expect(car).to respond_to(:start!)
  end

  it "changes all state fields separately" do
    car.state = :idle
    car.engine = :stopped

    expect { car.start! }.to change { car.engine }
    expect { car.ride! }.to change { car.state }
    expect(car.state).to eq(:riding)
    expect(car.engine).to eq(:started)
  end

  it "raises error when defining exists machine" do
    expect { ExistsCar.instance_eval { statum :state } }
      .to raise_error(Statum::ExistingMachineError)
  end
end
