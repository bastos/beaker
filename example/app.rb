#!/usr/bin/env ruby -I ../lib -I lib

require 'beaker'

class TestController
  def test(a, b)
    a + b
  end
end

Beaker.boot path: './', env: 'development' do |app|
  app.map :test, controller: TestController
end

Beaker.application.run!

