require "beaker/version"
require 'celluloid/io'
require 'bert'
require 'pry'
require 'yell'
require 'active_support/all'

Yell.new :stdout, :name => 'Beaker::Application'

module Beaker
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Application
    autoload :Dispatcher
    autoload :Server
    autoload :BertSocketHelper
  end

  class << self
    attr_accessor :shared_application

    def application
      self.shared_application
    end

    def boot(options, &block)
      self.shared_application = Application.new(options[:path], options[:env])
      block.call(self.application)
    end
  end

  BeakerController = Struct.new(:name, :controller)
end

