require 'socket'

class MyServer

  attr_reader :tcp_server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @number_of_requests = 0
    @guess_counter = 0
    @server_should_exit = false
  end

  def handle_root(request_lines, path)
    # Would this be better as a hash?
    verb = request_lines[0].split[0]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[-3].split(":")[1].lstrip

    header_string = <<END_OF_HEADERS
    <pre>
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      Host: #{host}
      Port: #{port}
      Origin: #{origin}
      Accept: #{accept}
    </pre>
END_OF_HEADERS
  end


  def handle_hello
    @counter += 1
    "<h1> Hello, World! (#{@counter}) </h1>"
  end


  def handle_date_time
    "<h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1>"
  end


  def handle_word_search(word)
    dictionary = File.read("/usr/share/dict/words").split("\n")
    if
    dictionary.include?(word.downcase) == true
      "#{word.upcase} is a known word."
    else
      "#{word.upcase} is not a known word."
    end
  end


  def handle_start_game
    @number = Random.new.rand(1..100)
    @guesses = []
    "Good luck!"
  end


  def handle_game_post(content_length)
    guess = @client.read(content_length).split("=")[1].to_i
    @guesses << guess
    "Recorded your guess: #{guess}. You've made these guesses #{@guesses}."
  end

  def handle_game_get
    if @number > @guesses[-1]
      "Your guess: #{@guesses[-1]} is too low. You have taken #{@guesses.length} guesses."
    elsif @number < @guesses[-1]
      "Your guess: #{@guesses[-1]} is too high. You have taken #{@guesses.length} guesses."
    else @number ==  @guesses[-1]
    "Your guess: #{@guesses[-1]} is correct! You have taken #{@guesses.length} guesses."
    end
  end


  def handle_shut_down
    @server_should_exit = true
    "<h1>Total Requests: #{@number_of_requests}</h1>"
  end

#Switch to Ruby case statement?
# case path
  def determine_path(request_lines, path, verb)
    if path == '/'
      response = handle_root(request_lines, path)
    elsif path == '/hello'
      response = handle_hello
    elsif path == '/datetime'
      response = handle_date_time
    elsif path.include?('/word_search')
      word = path.split("=")[1]
      response = handle_word_search(word)
    elsif path == '/start_game' && verb == 'POST'
      response = handle_start_game
    elsif path.include?('/game')
      if verb == 'POST'
        content_length = request_lines[3].split[1].to_i
        response = handle_game_post(content_length)
      else
        response = handle_game_get
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
