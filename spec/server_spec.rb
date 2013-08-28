require 'spec_helper'

require 'bertrpc'

describe Beaker::Server do

  before do
    Beaker.boot(path: 'app', env: 'development') do |app|
      app.map :test, controller: TestController
      app.map :users, controller: UsersController
    end
  end

  context "#handle_connection" do

    it "handles existing controller methods" do
      with_tcp_server do |server|
        svc = BERTRPC::Service.new(example_addr, example_port)
        result = svc.call.users.show(1)
        expect(result).to eq("1")
      end
    end

    it "handles any exceptions" do
      with_tcp_server do |server|
        svc = BERTRPC::Service.new(example_addr, example_port)
        Beaker::Server.any_instance.should_receive(:handle_exception!) do |options|
          options[:socket].close
        end

        expect { svc.call.test.exception_test(1, 2) }.to raise_error
      end
    end
  end
end
