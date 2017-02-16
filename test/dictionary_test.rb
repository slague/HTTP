require 'minitest/autorun'
require 'minitest/pride'
require './lib/my_server'
require './lib/dictionary'
require 'faraday'


class DictionaryTest < Minitest::Test


  def test_it_handles_word_search
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=dog'
    result = "<html><head></head><body>DOG is a known word.</body></html>"
    assert_equal result, response.body
  end

end
