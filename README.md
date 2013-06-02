# Beaker

A simple [BERT-RPC](http://bert-rpc.org/) server built on top of [Celluloid](http://celluloid.io/).

    BERT and BERT-RPC are an attempt to specify a flexible binary serialization
    and RPC protocol that are compatible with the philosophies of dynamic languages
    such as Ruby, Python, PERL, JavaScript, Erlang, Lua, etc.

## Installation

Add this line to your application's Gemfile:

    gem 'beaker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beaker

## Usage

```ruby
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
```

## TODO

* More examples
* cast, info and the rest of BERT-RPC protocol

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

[Tiago Bastos](http://github.com/bastos) and [Eduardo Gurgel](https://github.com/edgurgel)
