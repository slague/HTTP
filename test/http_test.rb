require 'minitest/autorun'
require 'minitest/pride'
require './lib/http'
require 'faraday'


class HTTPTest < Minitest::Test

  def test_it_handles_root
    skip
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


  def test_it_handles_hello
    skip
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    result = "<html><head></head><body><h1> Hello, World! (1) </h1></body></html>"
    assert_equal result, response.body
  end


  def test_it_handles_date_time
    skip
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    result = "<html><head></head><body><h1>20:15PM on Tuesday, February 14, 2017</h1></body></html>"
    assert_equal result, response.body
  end


  def test_it_handles_word_search
    skip
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=dog'
    result = "<html><head></head><body>DOG is a known word.</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_start_game
    skip
    response = Faraday.post 'http://127.0.0.1:9292/start_game'
    result = "<html><head></head><body>Good luck!</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_game_post
    skip
    response = Faraday.post 'http://127.0.0.1:9292/game'
    result = "<html><head></head><body>Recorded your guess: 40. You've made these guesses [40].</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_game_get
    skip
    response = Faraday.get 'http://127.0.0.1:9292/game?guess=67'
    result = "<html><head></head><body>Your guess: 67 is too high. You have taken 2 guesses.</body></html>"
    assert_equal result, response.body
  end

  def test_it_handles_shut_down
    skip
    response = Faraday.get 'http://127.0.0.1:9292/shutdown'
    result = "<html><head></head><body><h1>Total Requests: 1</h1></body></html>"

    assert_equal result, response.body
  end

  def test_determine_path
    server = MyServer.new
    result = "<h1> Hello, World! (1) </h1>"
    assert_equal result, server.determine_path(["GET /shutdown HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Postman-Token: 39efff9b-0547-333c-8653-97efb910fc80", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36", "Content-Type: application/x-www-form-urlencoded", "Accept: */*", "Accept-Encoding: gzip, deflate, sdch, br", "Accept-Language: en-US,en;q=0.8"], "/hello", "GET")
  end

  def test_response_to_requests
    skip
    server = MyServer.new
    # assert_equal server opens, server.respond_to_requests
  end

end
