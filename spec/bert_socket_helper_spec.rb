require 'spec_helper'

describe Beaker::BertSocketHelper do
  let(:socket) { double(:socket) }

  context "writing data" do
    before do
    end

    describe '#write_reply' do
      let(:reply) { "reply" }
      let(:encoded_reply) { "encoded_reply" }
      let(:packed_data_size) { [encoded_reply.length].pack("N") }

      it "returns BERTRPC reply" do
        expect(BERT).to receive(:encode).with(t[:reply, reply]).and_return(encoded_reply)
        expect(socket).to receive(:write).with(packed_data_size)
        expect(socket).to receive(:write).with(encoded_reply)
        Beaker::BertSocketHelper.write_reply(socket, reply)
      end
    end

    describe '#write_no_reply' do
      let(:encoded_noreply) { "noreply" }
      let(:packed_data_size) { [encoded_noreply.length].pack("N") }

      it "returns BERTRPC noreply" do
        expect(BERT).to receive(:encode).with(t[:noreply]).and_return(encoded_noreply)
        expect(socket).to receive(:write).with(packed_data_size)
        expect(socket).to receive(:write).with(encoded_noreply)
        Beaker::BertSocketHelper.write_noreply(socket)
      end
    end

    describe '#write_no_method_error' do
      let(:encoded_error) { "error" }
      let(:packed_data_size) { [encoded_error.length].pack("N") }

      it "returns BERTRPC error" do
        expect(BERT).to receive(:encode).with([:error, [:server, 2, "Beaker", "function method not found on module module", []]]).and_return(encoded_error)
        expect(socket).to receive(:write).with(packed_data_size)
        expect(socket).to receive(:write).with(encoded_error)
        Beaker::BertSocketHelper.write_no_method_error(socket, :method, :module)
      end
    end

    describe '#write_no_module_error' do
      let(:encoded_error) { "error" }
      let(:packed_data_size) { [encoded_error.length].pack("N") }

      it "returns BERTRPC error" do
        expect(BERT).to receive(:encode).with([:error, [:server, 1, "Beaker", "Module module not found", []]]).and_return(encoded_error)
        expect(socket).to receive(:write).with(packed_data_size)
        expect(socket).to receive(:write).with(encoded_error)
        Beaker::BertSocketHelper.write_no_module_error(socket, :module)
      end
    end

    describe '#write_no_route_error' do
      let(:encoded_error) { "error" }
      let(:packed_data_size) { [encoded_error.length].pack("N") }

      it "returns BERTRPC error" do
        expect(BERT).to receive(:encode).and_return(encoded_error)
        expect(socket).to receive(:write).with(packed_data_size)
        expect(socket).to receive(:write).with(encoded_error)
        Beaker::BertSocketHelper.write_noreply(socket)
      end
    end
  end

  describe '#read_bert' do
      let(:len) { 100 }
      let(:bert) { double(:bert) }
      let(:decoded_bert) { double(:decoded_bert) }
    it "reads BERT data" do
      expect(socket).to receive(:readpartial).with(4).and_return(double(:data, unpack: [len]))
      expect(socket).to receive(:readpartial).with(len).and_return(bert)
      expect(BERT).to receive(:decode).with(bert).and_return(decoded_bert)
      expect(Beaker::BertSocketHelper.read_bert(socket)).to eq(decoded_bert)
    end
  end
end
