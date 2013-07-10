require 'spec_helper'

describe Beaker::Application do
  before do
    Beaker.boot(path: 'app', env: 'development') do |app|
      app.map :test, controller: TestController
    end
  end

  it "has an environment" do
    expect(Beaker.application.environment).to eq('development')
  end

  it "has a path" do
    expect(Beaker.application.root_path).to eq('app')
  end

  it "has an instance of Beaker::BeakerController" do
    expect(Beaker.application.controllers[:test]).to be_a(Beaker::BeakerController)
  end

  it "maps controllers" do
    Beaker.application.map :users, controller: UsersController
    expect(Beaker.application.controllers[:users]).to be_a(Beaker::BeakerController)
  end

  it "loads rake tasks" do
    expect(Beaker.application).to receive(:load).with("beaker/tasks/server.rake").and_return(true)
    expect(Beaker.application).to receive(:load).with("beaker/tasks/console.rake").and_return(true)

    Beaker.application.load_rake_tasks
  end
end
