module Beaker
  module BertSocketHelper
    class << self
      def write_no_module_error(socket, moduleh)
        send_data = BERT.encode(t[:error, [:server, 1, 'Beaker', "Module #{moduleh} not found", []]])
        write(socket, send_data)
      end

      def write_no_method_error(socket, method, moduleh)
        send_data = BERT.encode(t[:error, [:server, 2, 'Beaker', "function #{method} not found on module #{moduleh}", []]])
        write(socket, send_data)
      end

      def write_reply(socket, resp)
        send_data = BERT.encode(t[:reply, resp])
        write(socket, send_data)
      end

      def write_noreply(socket)
        send_data = BERT.encode(t[:noreply])
        write(socket, send_data)
      end

      def read_bert(socket)
        len = socket.readpartial(4).unpack('N').first
        bert_request = socket.readpartial(len)
        BERT.decode(bert_request)
      end

      private

      def write(socket, send_data)
        socket.write([send_data.length].pack("N"))
        socket.write(send_data)
      end
    end
  end
end
