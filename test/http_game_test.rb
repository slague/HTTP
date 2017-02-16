require 'minitest/autorun'
require 'minitest/pride'
require './lib/my_server'
require './lib/http_game'
require 'faraday'


class GameTest < Minitest::Test

  def test_it_handles_start_game
    response = Faraday.post 'http://127.0.0.1:9292/start_game'
    result = "<html><head></head><body>Good luck!</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_game_post
    response = Faraday.post 'http://127.0.0.1:9292/game'
    result = "<html><head></head><body>Recorded your guess: 0. You've made these guesses [0].</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_game_get
    skip
    response = Faraday.get 'http://127.0.0.1:9292/game?guess=67'
    result = "<html><head></head><body>Your guess: 40 is too low. You have taken 1 guesses.</body></html>"
    assert_equal result, response.body
  end







end
