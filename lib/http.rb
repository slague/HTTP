require 'socket'
# require 'my_server'

# "Best" case scenario
# server = MyServer.new(9292)
# server.connect
# server.wait_for_requests
# For testing... See "Tooling" section item #3


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
  dictionary.include?(word) == true
    "#{word} is a known word."
  else
    "#{word} is not a known word."
  end
end

def handle_start_game
  @number = Random.new.rand(1..100)
  "Good luck!"
end

def handle_game_get(guess)
  "You have taken #{@guess_counter} guesses."

  if @number > guess
    "Your guess: #{guess} is too low."
  elsif @number < guess
    "Your guess: #{guess} is too high."
  else @number == guess
  "Your guess: #{guess} is correct!"
  end
end

def handle_game_post(guess)
  @guess_counter += 1
  handle_game_get(guess)
end

# GET
# a) how many guesses have been taken.
# b) if a guess has been made, it tells what the guess was and whether it was too high, too low, or correct


# POST
# This is how we make a guess. The request includes a parameter named guess. The server stores the guess and sends the user a redirect response, causing the client to make a GET to /game.


def handle_shut_down
  @server_should_exit = true
  "<h1>Total Requests: #{@number_of_requests}</h1>"
end

tcp_server = TCPServer.new(9292)
@counter = 0
@number_of_requests = 0
@guess_counter = 0
@server_should_exit = false

puts "Ready for a request"


#case when
until @server_should_exit
  client = tcp_server.accept

  request_lines = []

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  path = request_lines[0].split[1]
  @number_of_requests += 1

  # Switch to Ruby case statement?

  if path == '/favicon.ico'
    client.puts ["http/1.1 404 not-found"]
    next
  elsif path == '/'
    response = handle_root(request_lines, path)
  elsif path == '/hello'
    response = handle_hello
  elsif path == '/datetime'
    response = handle_date_time
  elsif path.include?('/word_search')
    word = path.split("=")[1]
    response = handle_word_search(word)
  elsif path == '/start_game'
    response = handle_start_game
  elsif path.include?('/game?')
    guess = path.split("=")[1].to_i
    response = handle_game_post(guess)
  elsif path == '/shutdown'
    response = handle_shut_down
  end


  puts "Sending response."

  # send_response method?
  output = "<html><head></head><body>#{response}</body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output

  puts ["Wrote this response:", headers, output].join("\n")

  puts "\nResponse complete, exiting."
end

client.close
