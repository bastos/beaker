module Beaker
  class Application
    include Yell::Loggable

    attr_accessor :controllers, :root_path, :environment

    def initialize(path, env)
      self.root_path = path
      self.environment = env
      self.controllers = {}
      initialize_logger
    end

    def controller(moduleh)
      controllers[moduleh][:controller].new
    end

    def controller?(moduleh)
      controllers.key?(moduleh)
    end

    def map(name, *options)
      options = options.extract_options!
      self.controllers[name] = BeakerController.new(name,
                                                    options[:controller])
    end

    def run!
      supervisor = Server.supervise("127.0.0.1", 9999)
      trap("INT") { supervisor.terminate; exit }
      trap("TERM") { supervisor.terminate; exit }
      sleep
    end

    def console!
      Pry.start
    end

    def load_rake_tasks
      load "beaker/tasks/server.rake"
      load "beaker/tasks/console.rake"
    end

    # TODO
    def initialize_logger
    end
  end
end

