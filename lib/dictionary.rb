class Dictionary

  def initialize
    @dictionary = File.read("/usr/share/dict/words").split("\n")
  end

  def word_search
    if
      @dictionary.include?(word) == true
      "#{word} is a known word."
    else
      "#{word} is not a known word."
    end
  end
end
