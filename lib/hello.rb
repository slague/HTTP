
class Hello

  def initialize
    @counter = 0
  end

  def handle_hello
    @counter += 1
    "<h1> Hello, World! (#{@counter}) </h1>"
  end

end
