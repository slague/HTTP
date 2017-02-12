require 'socket'
tcp_server = TCPServer.new(9292)


puts "Ready for a request"

counter = 1

while client = tcp_server.accept
  request_lines = []

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  puts "Sending response."

  response = "<h1>" + "Hello, world! #{counter}\n" + "</h1>"
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
  counter += 1
end

client.close
