require 'socket'
require_relative 'dictionary'
require_relative 'request_handler'
# require 'my_server'

# "Best" case scenario
# server = MyServer.new(9292)
# server.connect
# server.wait_for_requests
# For testing... See "Tooling" section item #3

class HTTPServer

  attr_reader :tcp_server, :request

  def initialize
    @tcp_server = TCPServer.new(9292)
  end


  def connect
    until request.server_should_exit
      client = tcp_server.accept
      request.receive_request(client)
      response
    end
    client.close
  end

  def response
    puts "Sending response."

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

end

if __FILE__ ==$0
server = HTTPServer.new
server.connect
end
