require 'minitest/autorun'
require 'minitest/pride'
require './lib/my_server'
require './lib/date_time'
require 'faraday'



class DateTimeTest < Minitest::Test


  def test_it_handles_date_time
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    result = "<html><head></head><body><h1>08:34AM on Thursday, February 16, 2017</h1></body></html>"
    assert_equal result, response.body
  end

end
