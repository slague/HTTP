require 'minitest/autorun'
require 'minitest/pride'
require './lib/my_server'
require './lib/root'
require 'faraday'



class RootTest < Minitest::Test

  def test_it_handles_root
    response = Faraday.get 'http://127.0.0.1:9292'
    result =  "<html><head></head><body>    <pre>
      Verb: GET
      Path: /
      Protocol: HTTP/1.1
      Host: Faraday v0.11.0
      Port:
      Origin: Faraday v0.11.0
      Accept: */*
    </pre>
</body></html>"

    assert_equal result, response.body
  end

end
