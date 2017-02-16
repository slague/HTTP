require 'minitest/autorun'
require 'minitest/pride'
require './lib/my_server'
require './lib/hello'
require 'faraday'



class HelloTest < Minitest::Test

  def test_it_handles_hello
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    result = "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>"
    assert_equal result, response.body
  end


end
