class Dictionary

  def initialize
    @dictionary = File.read("/usr/share/dict/words").split("\n")
  end

  def word_search(word)
    if
      @dictionary.include?(word) == true
      "#{word.upcase} is a known word."
    else
      "#{word.upcase} is not a known word."
    end
  end
end
