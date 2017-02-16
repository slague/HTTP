require 'socket'
require './lib/root'
require './lib/hello'
require './lib/date_time'
require './lib/dictionary'
require './lib/http_game'



class MyServer

  attr_reader :tcp_server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @number_of_requests = 0
    @server_should_exit = false
    @game = Game.new
    @dictionary = Dictionary.new
    @root = Root.new
    @hello = Hello.new
    @date_time = DateTime.new
  end


  def handle_shut_down
    @server_should_exit = true
    "<h1>Total Requests: #{@number_of_requests}</h1>"
  end

  def determine_path(request_lines, path, verb)
    if path == '/'
      response = @root.handle_root(request_lines, path)
    elsif path == '/hello'
      # response = handle_hello
      response = @hello.handle_hello
    elsif path == '/datetime'
      # response = handle_date_time
      response = @date_time.handle_date_time
    elsif path.include?('/word_search')
      word = path.split("=")[1]
      response = @dictionary.word_search(word)
    elsif path == '/start_game' && verb == 'POST'
      response = @game.handle_start_game
    elsif path.include?('/game')
      if verb == 'POST'
        content_length = request_lines[3].split[1].to_i
        guess = @client.read(content_length).split("=")[1].to_i
        response = @game.handle_game_post(content_length, guess)
      else
        response = @game.handle_game_get
      end
    elsif path == '/shutdown'
      response = handle_shut_down
    end
    response
  end


  def respond_to_requests
    puts "Ready for a request"

    until @server_should_exit
      @client = tcp_server.accept
      request_lines = []

      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      puts request_lines.inspect

      @path = request_lines[0].split[1]
      @verb = request_lines[0].split[0]
      @number_of_requests += 1

      @response = determine_path(request_lines, @path, @verb)


      puts "Sending response."

      # send_response method?
      output = "<html><head></head><body>#{@response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      @client.puts headers
      @client.puts output
      puts ["Wrote this response:", headers, output].join("\n")

      puts "\nResponse complete, exiting."
    end

      @client.close
  end

end
