require 'spec_helper'

require 'bertrpc'

describe Beaker::Dispatcher do
  before do
    Beaker.boot(path: 'app', env: 'development') do |app|
      app.map :test, controller: TestController
      app.map :users, controller: UsersController
    end
  end
  describe ".dispatch!" do
    let(:socket) { double(:socket) }
    let(:dispatcher) { Beaker::Dispatcher.new(socket, Beaker.application) }
    let(:controller) { double(:controller) }

    context "receiving a valid route" do
      let(:response) { double(:response) }

      it "dispatches to correct route" do
        expect(Beaker::BertSocketHelper).to receive(:read_bert).and_return([:call, :users, :show, [1]])

        expect(Beaker.application).to receive(:controller?).and_return(true)
        expect(Beaker.application).to receive(:controller).and_return(controller)
        expect(controller).to receive(:respond_to?).and_return(true)

        expect(controller).to receive(:send).with(:show, 1).and_return(response)

        expect(Beaker::BertSocketHelper).to receive(:write_reply).with(socket, response)

        dispatcher.dispatch!
      end
    end

    context "receiving a invalid route" do
      context "invalid method" do
        it "dispatches to correct route" do
          expect(Beaker::BertSocketHelper).to receive(:read_bert).and_return([:call, :useers, :show, [1]])


          expect(Beaker.application).to receive(:controller?).and_return(false)
          expect(Beaker.application).not_to receive(:controller).and_return(controller)

          expect(Beaker::BertSocketHelper).to receive(:write_no_module_error).with(socket, :useers)

          dispatcher.dispatch!
        end
      end

      context "invalid method" do
        it "dispatches to correct route" do
          expect(Beaker::BertSocketHelper).to receive(:read_bert).and_return([:call, :users, :shows, [1]])


          expect(Beaker.application).to receive(:controller?).and_return(true)
          expect(Beaker.application).to receive(:controller).and_return(controller)
          expect(controller).to receive(:respond_to?).and_return(false)

          expect(Beaker::BertSocketHelper).to receive(:write_no_method_error).with(socket, :shows, :users)

          dispatcher.dispatch!
        end
      end
    end
  end
end
