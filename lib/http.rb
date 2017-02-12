require 'socket'
tcp_server = TCPServer.new(9292)


puts "Ready for a request"


while client = tcp_server.accept
  request_lines = []

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  verb = request_lines[0].split[0]
  path = request_lines[0].split[1]

  if path == '/favicon.ico'
    client.puts ["http/1.1 404 not-found"]
    next
  end

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

  # require "pry"; binding.pry

  puts "Sending response."

  response = header_string
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
