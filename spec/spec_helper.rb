require 'beaker'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Celluloid.shutdown
    Celluloid.boot
    FileUtils.rm("/tmp/cell_sock") if File.exist?("/tmp/cell_sock")
  end
end

def example_addr; '127.0.0.1'; end
def example_port; 1985; end
def example_unix_sock; '/tmp/cell_sock'; end

def with_tcp_server
  server = Beaker::Server.new(example_addr, example_port)
  yield server
end


class TestController
  def test(a, b)
    a + b
  end
end

class UsersController
  def show(id)
    id.to_s
  end
end

