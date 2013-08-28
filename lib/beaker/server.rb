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
      application = Beaker.application
      application.logger.info "Accepted connection from #{host}:#{port}"
      loop do
        application.logger.info "Received request from #{host}:#{port}"
        dispatcher = Dispatcher.new(socket, application)
        dispatcher.dispatch!
      end
    rescue EOFError => ex
      application.logger.info "Disconnected from #{host}:#{port} Error: #{ex.message}"
      socket.close
     rescue Exception => boom
       handle_exception!({ exception: boom,
                           application: application,
                           socket: socket,
                           port: port,
                           host: host })
    end

    def finalize
      @server.close if @server
    end

    private

    def handle_exception!(options)
      host = options[:host]
      port = options[:port]
      exception = options[:exception]

      msg = ["#{host}:#{port} error #{exception.class} #{exception.message}", *exception.backtrace].join("\n\t")
      options[:application].logger.error(msg)
      options[:socket].close
    end
  end
end
