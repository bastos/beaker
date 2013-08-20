module Beaker
  class Server
    include Celluloid::IO
    finalizer :finalize

    def initialize(host, port)
      @server = TCPServer.new(host, port)
      async.run
    end

    def run
      loop { async.handle_connection @server.accept }
    end

    def handle_connection(socket)
      _, port, host = socket.peeraddr
      loop do
        application = Beaker.application
        application.logger.info "Received connection from #{host}:#{port}"
        dispatcher = Dispatcher.new(socket, application)
        dispatcher.dispatch!
      end
    rescue EOFError
      # application.logger.info "#{host}:#{port} disconnected"
      socket.close
    end

    def finalize
      @server.close if @server
    end
  end
end

