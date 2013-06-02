module Beaker
  class Dispatcher
    attr_accessor :socket, :application

    def initialize(socket, application)
      self.socket = socket
      self.application = application
    end

    def dispatch!
      bert_request_decoded = BertSocketHelper::read_bert(socket)
      action = bert_request_decoded[0]
      moduleh = bert_request_decoded[1]

      if application.controller?(moduleh)
        method = bert_request_decoded[2]
        args = bert_request_decoded[3]
        controller = application.controller(moduleh)

        if controller.respond_to?(method)
          if action == :call
            resp = controller.send(method, *args)
            BertSocketHelper::write_reply(socket, resp)
          elsif action == :cast
            BertSocketHelper::write_no_reply(socket)
            controller.send(method, *args) # FIXME I'm async! :)
          end
        else
          BertSocketHelper::write_no_method_error(socket, method, moduleh)
        end

      else
        BertSocketHelper::write_no_module_error(socket, moduleh)
      end
    end

  end
end
