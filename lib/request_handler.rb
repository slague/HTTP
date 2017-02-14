class RequestHandler

  attr_reader :counter, :number_of_requests, :server_should_exit
  def initialize
    @counter = 0
    @number_of_requests = 0
    @server_should_exit = false
  end

  def receive_request(client)
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    puts "Got this request:"
    puts request_lines.inspect

    path = request_lines[0].split[1]
    @number_of_requests += 1
    path_finder(request_lines, path)
  end

def path_finder(request_lines, path)
  # # if path == '/favicon.ico'
  # #   client.puts ["http/1.1 404 not-found"]
  #   next
  if path == '/'
    response = handle_root(request_lines, path)
  elsif path == '/hello'
    response = handle_hello
  elsif path == '/datetime'
    response = handle_date_time
  elsif path.include?('/word_search')
    word = path.split("=")[1]
    response = handle_word_search(word)
  elsif path == '/shutdown'
    response = handle_shut_down
  end
end

  def handle_root(request_lines, path)
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
    "<h1> Hello, World! (#{counter}) </h1>"
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

  def handle_shut_down
    @server_should_exit = true
    "<h1>Total Requests: #{number_of_requests}</h1>"
  end

end
