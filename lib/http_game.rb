
class Game


  def handle_start_game
    @number = Random.new.rand(1..100)
    @guesses = []
    "Good luck!"
  end


  def handle_game_post(content_length, guess)
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

end
